require "net/http"

class PlayerImporter < ServiceObject
  def call
    import_all_teams
  end

  private

  def import_all_teams
    Mlb::Constants::TEAMS.values.each { |team_id| import_mlb_roster(team_id) }
  end

  def import_mlb_roster(team_id)
    players = Mlb::Client.fetch_40_man_roster(team_id)

    players.each do |player|
      player_name = player.dig("person", "fullName")
      Player.create_or_find_by(searchable_name: Player.searchable_name(player_name), team: team_abbreviation(team_id)) do |player|
        player.name = player_name
      end
    end
  end

  def team_abbreviation(team_id)
    Mlb::Constants::TEAMS.key(team_id)
  end
end
