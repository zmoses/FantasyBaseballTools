class RankingsAggregator < ServiceObject
  def call
    all_rankings_importers.each(&:call)
  end

  private

  def all_rankings_importers
    # Need to load all the importer classes or .descendants won't fine them.
    Dir[Rails.root.join("app/services/*/*_importer.rb")].each { |file| require file }

    BaseImporter.descendants
  end
end
