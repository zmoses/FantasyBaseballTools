require "net/http"

class PlayerImporter < ServiceObject
  def call
    import_all_teams
  end

  private

  def import_all_teams
    Mlb::Constants::TEAMS.values.each { |team_id| import_team(team_id) }
  end

  def import_mlb_rosters(team_id)
    players = Mlb::Client.fetch_40_man_roster(team_id)

    players.each do |player|
      Player.create_or_find_by(name: p["person"]["fullName"], team: team_abbreviation(team_id))
    end
  end

  def team_abbreviation(team_id)
    Mlb::Constants::Mlb::Constants::TEAMS.key(team_id)
  end
end
