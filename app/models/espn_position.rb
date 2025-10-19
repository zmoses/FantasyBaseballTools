class EspnPosition < ApplicationRecord
  has_and_belongs_to_many :players

  class UnknownPositionError < StandardError; end

  def self.position_map(position)
    # Valid positions, return as-is
    return position if [ "1B", "2B", "3B", "SS", "C", "RP", "SP", "DH", "OF" ].include?(position)

    # ESPN doesn't distinguish between outfield positions
    return "OF" if [ "LF", "RF", "CF" ].include?(position)

    raise UnknownPositionError, "Unknown position: #{position}"
  end
end
