class ImportRankingsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    RankingsAggregator.call
  end
end
