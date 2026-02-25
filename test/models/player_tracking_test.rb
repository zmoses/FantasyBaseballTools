require "test_helper"

class PlayerTrackingTest < ActiveSupport::TestCase
  test "belongs to player" do
    player = create(:player, :aaron_judge)
    tracking = create(:player_tracking, player: player)

    assert_equal player, tracking.player
  end

  test "requires player" do
    tracking = PlayerTracking.new(notes: "Some notes")

    assert_not tracking.valid?
    assert_includes tracking.errors[:player], "must exist"
  end

  test "claimed defaults to false" do
    player = create(:player, :aaron_judge)
    tracking = PlayerTracking.create!(player: player)

    assert_not tracking.claimed
  end

  test "notes can be nil" do
    player = create(:player, :aaron_judge)
    tracking = create(:player_tracking, player: player, notes: nil)

    assert_nil tracking.notes
  end

  test "notes can be empty string" do
    player = create(:player, :aaron_judge)
    tracking = create(:player_tracking, player: player, notes: "")

    assert_equal "", tracking.notes
  end
end
