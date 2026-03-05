class Player < ApplicationRecord
  has_and_belongs_to_many :espn_positions
  has_many :league_players, dependent: :destroy
  has_many :user_players, dependent: :destroy
  validates :searchable_name, uniqueness: { scope: :mlb_team }

  def claimed?
    player_tracking&.claimed
  end

  def notes
    player_tracking&.notes
  end

  class UnknownPlayerNameError < StandardError; end

  def self.searchable_name(name)
    name_no_suffix = name.downcase.gsub("-", " ").gsub(/ (jr|sr|jr\.|sr\.|ii|iii|iv|v)$/, "")
    transliterated_name = ActiveSupport::Inflector.transliterate(name_no_suffix)
    transliterated_name.gsub(/[^0-9a-z\s]/, "").split(" ").reject { |part| part.length == 1 }.join("")
  end

  def add_position_eligibility(position)
    espn_position = EspnPosition.find_or_create_by(position: position)
    self.espn_positions << espn_position unless self.espn_positions.include?(espn_position)
  end

  def self.find_best_match(name:, mlb_team: nil, position: nil)
    # TODO: hard code fixes are gross. See if we can handle these edge cases better.
    # Two Max Muncys who play the same position, and CBS doesn't provide a mlb_team. One is fantasy irrelevant, so assume we mean the LAD one
    mlb_team = "LAD" if Player.searchable_name(name) == "maxmuncy"
    # Zach == Zachary
    name = "zachneto" if Player.searchable_name(name) == "zacharyneto"
    # Josh == Joshua
    name = "joshlowe" if Player.searchable_name(name) == "joshualowe"
    # Mike == Michael
    name = "michaelsoroka" if Player.searchable_name(name) == "mikesoroka"
    # Ohtani is both a pitcher and a hitter, but ESPN counts them as one player
    raise UnknownPlayerNameError if Player.searchable_name(name) == "shoheiohtanipitcher"
    # Dude's an idiot and probably won't every play in the MLB again
    raise UnknownPlayerNameError if Player.searchable_name(name) == "emmanuelclase"
    # Free agent, not on the 40 man anywhere and therefore not in the DB
    raise UnknownPlayerNameError if Player.searchable_name(name) == "ryanpressly"

    where_clause = { searchable_name: Player.searchable_name(name) }
    where_clause[:mlb_team] = mlb_team if mlb_team
    begin
      where_clause[:espn_positions] = { position: EspnPosition.position_map(position) } if position
    rescue EspnPosition::UnknownPositionError
      # TODO: Remove pry, but nice to have for now until the possibility of putting this on a deployed environment with error tracking
      binding.pry
    end
    matching_players = Player.left_joins(:espn_positions).where(where_clause).distinct

    return matching_players.first if matching_players.count == 1

    raise UnknownPlayerNameError, "(#{matching_players.count} matches) players found with params: name(#{name}) mlb_team(#{mlb_team}) position(#{position})" if matching_players.count.positive?

    # If we have no matches, loosen the params and try again
    if matching_players.count.zero?
      # Try search with no mlb_team - maybe got traded or is a free agent now?
      if mlb_team.present?
        matching_players = Player.left_joins(:espn_positions).where(where_clause.reject { |key| key == :mlb_team }).distinct
        return matching_players.first if matching_players.count == 1
      end

      # Try search with no position - maybe just DHs now?
      if position.present?
        matching_players = Player.left_joins(:espn_positions).where(where_clause.reject { |key| key == :espn_positions }).distinct
        return matching_players.first if matching_players.count == 1
      end

      # Try just with the name - who knows
      matching_players = Player.where(searchable_name: Player.searchable_name(name))
      return matching_players.first if matching_players.count == 1

      raise UnknownPlayerNameError, "Couldn't find player #{name} (#{matching_players.count} matches)"
    end
  end
end
