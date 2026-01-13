require "test_helper"

class EspnPositionTest < ActiveSupport::TestCase
  test "has_and_belongs_to_many players association" do
    position = create(:espn_position, :outfield)
    player = create(:player, :aaron_judge)

    position.players << player

    assert_includes position.players, player
    assert_includes player.espn_positions, position
  end

  test ".position_map returns valid position unchanged" do
    assert_equal "1B", EspnPosition.position_map("1B")
    assert_equal "2B", EspnPosition.position_map("2B")
    assert_equal "3B", EspnPosition.position_map("3B")
    assert_equal "SS", EspnPosition.position_map("SS")
    assert_equal "C", EspnPosition.position_map("C")
    assert_equal "RP", EspnPosition.position_map("RP")
    assert_equal "SP", EspnPosition.position_map("SP")
    assert_equal "DH", EspnPosition.position_map("DH")
    assert_equal "OF", EspnPosition.position_map("OF")
  end

  test ".position_map converts LF to OF" do
    assert_equal "OF", EspnPosition.position_map("LF")
  end

  test ".position_map converts RF to OF" do
    assert_equal "OF", EspnPosition.position_map("RF")
  end

  test ".position_map converts CF to OF" do
    assert_equal "OF", EspnPosition.position_map("CF")
  end

  test ".position_map raises UnknownPositionError for invalid position" do
    assert_raises(EspnPosition::UnknownPositionError) do
      EspnPosition.position_map("INVALID")
    end
  end

  test ".position_map raises UnknownPositionError with descriptive message" do
    error = assert_raises(EspnPosition::UnknownPositionError) do
      EspnPosition.position_map("QB")
    end

    assert_equal "Unknown position: QB", error.message
  end
end
