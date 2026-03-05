class League < ApplicationRecord
  enum :platform, { fantrax: "Fantrax", espn: "ESPN" }, default: :fantrax, validate: true
  enum :scoring_format, { points: "points", categories: "categories" }, default: :points, validate: true

  before_save :compact_roster_slots

  has_many :league_players

  private

  def compact_roster_slots
    roster_slots.reject! { |_, v| v.to_i.zero? }
  end
end
