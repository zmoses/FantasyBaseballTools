class Player < ApplicationRecord
  has_and_belongs_to_many :espn_positions
  validates :searchable_name, uniqueness: { scope: :team }

  def self.searchable_name(name)
    name_no_suffix = name.downcase.gsub("-", " ").gsub(/ (jr|sr|jr\.|sr\.|ii|iii|iv|v)$/, "")
    transliterated_name = ActiveSupport::Inflector.transliterate(name_no_suffix)
    transliterated_name.gsub(/[^0-9a-z\s]/, "").split(" ").reject { |part| part.length == 1 }.join("")
  end

  def add_position_eligibility(position)
    espn_position = EspnPosition.find_or_create_by(position: position)
    self.espn_positions << espn_position unless self.espn_positions.include?(espn_position)
  end

  def self.find_best_match(name:, team: nil, position: nil)
    # TODO: hard code fixes are gross. See if we can handle these edge cases better.
    # Two Max Muncys who play the same position, and CBS doesn't provide a team. One is fantasy irrelevant, so assume we mean the LAD one
    team = "LAD" if Player.searchable_name(name) == "maxmuncy"
    # Zach == Zachary
    name = "zachneto" if Player.searchable_name(name) == "zacharyneto"
    # Josh == Joshua
    name = "joshlowe" if Player.searchable_name(name) == "joshualowe"
    # Mike == Michael
    name = "michaelsoroka" if Player.searchable_name(name) == "mikesoroka"
    # Ohtani is both a pitcher and a hitter, but ESPN counts them as one player
    return nil if Player.searchable_name(name) == "shoheiohtanipitcher"
    # Dude's an idiot and probably won't every play in the MLB again
    return nil if Player.searchable_name(name) == "emmanuelclase"
    # Free agent, not on the 40 man anywhere and therefore not in the DB
    return nil if Player.searchable_name(name) == "ryanpressly"

    where_clause = { searchable_name: Player.searchable_name(name) }
    where_clause[:team] = team if team
    where_clause[:espn_positions] = { position: EspnPosition.position_map(position) } if position
    matching_players = Player.left_joins(:espn_positions).where(where_clause).distinct

    return matching_players.first if matching_players.count == 1

    raise "Couldn't uniquely identify player name(#{name}) team(#{team}) position(#{position}) (#{matching_players.count} matches)" if matching_players.count.positive?

    # If we have no matches, loosen the params and try again
    if matching_players.count.zero?
      # Try search with no team - maybe got traded or is a free agent now?
      if team.present?
        matching_players = Player.left_joins(:espn_positions).where(where_clause.reject { |key| key == :team }).distinct
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

      binding.pry
      raise "Couldn't find player #{name} (#{matching_players.count} matches)"
    end
  end
end
