class Player < ApplicationRecord
  has_and_belongs_to_many :espn_positions
  validates :searchable_name, uniqueness: { scope: :team }

  def self.searchable_name(name)
    transliterated_name = ActiveSupport::Inflector.transliterate(name)
    transliterated_name.gsub(/[^0-9A-Za-z\s]/, "").downcase.split(" ").reject { |part| part.length == 1 }.join("")
  end

  def add_position_eligibility(position)
    espn_position = EspnPosition.find_or_create_by(position: position)
    self.espn_positions << espn_position unless self.espn_positions.include?(espn_position)
  end
end
