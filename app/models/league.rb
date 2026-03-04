class League < ApplicationRecord
  enum :platform, { fantrax: "Fantrax", espn: "ESPN" }, default: :fantrax, validate: true
  enum :scoring_format, { points: "points", categories: "categories" }, default: :points, validate: true
end
