class ResetPlayersTableJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # We're going to start fresh
    Player.destroy_all

    # Import players from MLB 40-man rosters
    PlayerImporter.call

    # Assign fantasy rankings to imported players from various sources
    RankingsAggregator.call
  end
end
