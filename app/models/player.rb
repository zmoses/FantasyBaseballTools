class Player < ApplicationRecord
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

  def self.find_best_match(name:, mlb_team: nil, position: nil, league: nil)
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

    mapped_position = begin
      position && EspnPosition.position_map(position)
    rescue EspnPosition::UnknownPositionError
      nil
    end

    searchable = Player.searchable_name(name)
    scope = player_scope(searchable, mlb_team, mapped_position, league)

    return scope.first if scope.count == 1
    raise UnknownPlayerNameError, "(#{scope.count} matches) players found with params: name(#{name}) mlb_team(#{mlb_team}) position(#{position})" if scope.count > 1

    # 0 matches - loosen params and try again

    # Try without mlb_team - maybe got traded or is a free agent now?
    if mlb_team.present?
      scope = player_scope(searchable, nil, mapped_position, league)
      return scope.first if scope.count == 1
    end

    # Try without position - maybe just DHs now?
    if mapped_position.present? && league.present?
      scope = player_scope(searchable, mlb_team, nil, nil)
      return scope.first if scope.count == 1
    end

    # Try just with the name - who knows
    matches = Player.where(searchable_name: searchable)
    return matches.first if matches.count == 1

    raise UnknownPlayerNameError, "Couldn't find player #{name} (#{matches.count} matches)"
  end

  def self.player_scope(searchable, mlb_team, mapped_position, league)
    scope = where(searchable_name: searchable)
    scope = scope.where(mlb_team: mlb_team) if mlb_team
    if mapped_position && league
      scope = scope.joins(:league_players)
        .where(league_players: { league_id: league.id })
        .where("league_players.position_eligibility @> ?::jsonb", [ mapped_position ].to_json)
    end
    scope.distinct
  end
  private_class_method :player_scope
end
