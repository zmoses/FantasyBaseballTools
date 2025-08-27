class RankingsAggregator < ServiceObject
  def call
    all_rankings_importers.each(&:call)
  end

  private

  def all_rankings_importers
    # Need to load all the importer classes or .descendants won't fine them.
    Dir[Rails.root.join("app/services/*/*_importer.rb")].each { |file| require file }

    first_importer = Espn::RankingsImporter
    BaseImporter.descendants.reject { |descendant| descendant == first_importer }.unshift(first_importer)
  end
end
