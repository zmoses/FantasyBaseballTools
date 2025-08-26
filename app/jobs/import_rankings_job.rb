class ImportRankingsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Player.destroy_all

    PlayerImporter.call
    RankingsAggregator.call
  end
end
