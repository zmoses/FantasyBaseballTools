class EspnPosition < ApplicationRecord
  has_and_belongs_to_many :players

  class UnknownPositionError < StandardError; end

  def self.position_map(position)
    # ESPN doesn't distinguish between outfield positions in most leagues
    # Will eventually need changed to handle league custom settings
    return "OF" if [ "LF", "RF", "CF" ].include?(position)

    # Valid positions, return as-is
    return position if Espn::Constants::POSITIONS_BY_ID.values.include?(position)

    raise UnknownPositionError, "Unknown position: #{position}"
  end
end
