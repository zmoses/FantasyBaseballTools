class Player < ApplicationRecord
  validates :searchable_name, uniqueness: { scope: :team }

  def self.searchable_name(name)
    ActiveSupport::Inflector.transliterate(name).gsub(/[^0-9A-Za-z]/, "").downcase
  end
end
