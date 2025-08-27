class EspnPosition < ApplicationRecord
  has_and_belongs_to_many :players

  def self.position_map(position)
    # Valid positions, return as-is
    return position if [ "1B", "2B", "3B", "SS", "C", "RP", "SP", "DH", "OF" ].include?(position)

    # ESPN doesn't distinguish between outfield positions
    "OF" if [ "LF", "RF", "CF" ].include?(position)
  end
end
