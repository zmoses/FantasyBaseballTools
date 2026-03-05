class RankingsAggregator < ServiceObject
  def call(league)
    all_rankings_importers(league).each { |importer| importer.call(league) }
  end

  private

  def all_rankings_importers(league)
    # Need to load all the importer classes or .descendants won't fine them.
    Dir[Rails.root.join("lib/*/rankings_importer.rb")].each { |file| require file }

    # For my own personal purposes, I use ESPN and I want to grab their list first.
    # Eventually, I might implement a way to configure a primary source to grab first.
    first_importer = "#{league.platform.capitalize}::RankingsImporter".constantize
    importers = BaseRankingsImporter.descendants.reject { |descendant| descendant == first_importer }

    draft_start_time = @current_league.draft_started_at
    main_source_locked = draft_start_time ? draft_start_time < Time.now : false

    return importers if main_source_locked

    importers.unshift(first_importer)
  end
end
