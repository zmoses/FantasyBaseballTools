class SyncPlayersJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Track which players we see on 40-man rosters
    seen_player_ids = Set.new

    # Import players from MLB 40-man rosters (non-destructively)
    Mlb::Constants::TEAMS.each do |team_abbr, team_id|
      players = Mlb::Client.fetch_40_man_roster(team_id)

      players.each do |player_data|
        player_name = player_data.dig("person", "fullName")
        searchable = Player.searchable_name(player_name)

        player = Player.find_or_initialize_by(searchable_name: searchable)
        player.name = player_name
        player.mlb_team = team_abbr
        player.save!

        seen_player_ids << player.id
      end
    end

    # Mark players not found on any 40-man roster as free agents
    Player.where.not(id: seen_player_ids).where.not(team: "FA").update_all(team: "FA")

    # Assign fantasy rankings to imported players from various sources
    RankingsAggregator.call(league)
  end
end
