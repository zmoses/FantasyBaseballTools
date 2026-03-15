class LeaguePlayer < ApplicationRecord
  belongs_to :player
  belongs_to :league

  delegate :name, to: :player
end
