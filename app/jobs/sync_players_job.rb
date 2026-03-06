class SyncPlayersJob < ApplicationJob
  queue_as :default

  def perform(league:)
    # Track which players we see on 40-man rosters
    seen_player_ids = Set.new

    # Import players from MLB 40-man rosters (non-destructively)
    Mlb::Constants::TEAMS.each do |team_abbr, team_id|
      players = Mlb::Client.fetch_40_man_roster(team_id)

      players.each do |player_data|
        player_name = player_data.dig("person", "fullName")
        searchable = Player.searchable_name(player_name)

        # 1. Exact match (already on this team), 2. FA with same name (traded/re-signed), 3. Brand new
        player = Player.find_by(searchable_name: searchable, mlb_team: team_abbr) ||
          Player.find_by(searchable_name: searchable, mlb_team: "FA") ||
          Player.new(searchable_name: searchable)

        player.name = player_name
        player.mlb_team = team_abbr
        player.save!

        LeaguePlayer.find_or_initialize_by(league_id: league.id, player_id: player.id)
        UserPlayer.find_or_initialize_by(user_id: 1, player_id: player.id)

        seen_player_ids << player.id
      end
    end

    # Mark players not found on any 40-man roster as free agents
    Player.where.not(id: seen_player_ids).where.not(mlb_team: "FA").update_all(mlb_team: "FA")

    # Assign fantasy rankings to imported players from various sources
    RankingsAggregator.call(league)
  end
end
