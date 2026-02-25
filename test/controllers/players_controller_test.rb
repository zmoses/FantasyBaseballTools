require "test_helper"

class PlayersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @player = create(:player, :aaron_judge)
  end

  test "should show player" do
    get player_url(@player)
    assert_response :success
  end

  test "claim creates player_tracking and marks player as claimed" do
    assert_not @player.claimed?

    patch claim_player_url(@player)

    @player.reload
    assert @player.claimed?
    assert @player.player_tracking.present?
  end

  test "claim updates existing player_tracking if present" do
    tracking = create(:player_tracking, player: @player, claimed: false, notes: "Existing notes")

    patch claim_player_url(@player)

    tracking.reload
    assert tracking.claimed
    assert_equal "Existing notes", tracking.notes
  end

  test "claim responds with turbo_stream" do
    patch claim_player_url(@player), headers: { "Accept" => "text/vnd.turbo-stream.html" }

    assert_response :success
  end

  test "mark_all_unclaimed sets all player_trackings to unclaimed" do
    player1 = create(:player, :claimed_player)
    player2 = create(:player, :claimed_player)

    assert player1.claimed?
    assert player2.claimed?

    patch mark_all_unclaimed_players_url

    player1.reload
    player2.reload
    assert_not player1.claimed?
    assert_not player2.claimed?
  end

  test "mark_all_unclaimed redirects to draft board" do
    patch mark_all_unclaimed_players_url

    assert_redirected_to draft_board_index_path
  end

  test "update_notes creates player_tracking with notes" do
    assert_nil @player.notes

    patch update_notes_player_url(@player), params: { notes: "Great hitter" }

    @player.reload
    assert_equal "Great hitter", @player.notes
  end

  test "update_notes updates existing player_tracking notes" do
    tracking = create(:player_tracking, player: @player, notes: "Old notes", claimed: true)

    patch update_notes_player_url(@player), params: { notes: "New notes" }

    tracking.reload
    assert_equal "New notes", tracking.notes
    assert tracking.claimed
  end

  test "update_notes can clear notes" do
    create(:player_tracking, player: @player, notes: "Some notes")

    patch update_notes_player_url(@player), params: { notes: "" }

    @player.reload
    assert_equal "", @player.notes
  end

  test "update_notes responds with turbo_stream" do
    patch update_notes_player_url(@player),
      params: { notes: "Test notes" },
      headers: { "Accept" => "text/vnd.turbo-stream.html" }

    assert_response :success
  end
end
