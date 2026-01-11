class RankingsAggregator < ServiceObject
  def call
    all_rankings_importers.each(&:call)
  end

  private

  def all_rankings_importers
    # Need to load all the importer classes or .descendants won't fine them.
    Dir[Rails.root.join("lib/*/rankings_importer.rb")].each { |file| require file }

    # For my own personal purposes, I use ESPN and I want to grab their list first.
    # Eventually, I might implement a way to configure a primary source to grab first.
    first_importer = Espn::RankingsImporter
    BaseRankingsImporter.descendants.reject { |descendant| descendant == first_importer }.unshift(first_importer)
  end
end
