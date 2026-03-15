class UserPlayer < ApplicationRecord
  belongs_to :player

  delegate :name, to: :player
end
