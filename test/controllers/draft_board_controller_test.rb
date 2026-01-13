require "test_helper"

class DraftBoardControllerTest < ActionDispatch::IntegrationTest
  test "index renders successfully" do
    get draft_board_index_url
    assert_response :success
  end

  test "index displays unclaimed players with espn_rank" do
    aaron_judge = create(:player, :aaron_judge)
    max_muncy = create(:player, :max_muncy_lad)
    mike_trout = create(:player, :mike_trout)

    get draft_board_index_url
    assert_response :success

    # Should include unclaimed players with ESPN ranks in the response
    assert_select "tr##{dom_id(aaron_judge)}"
    assert_select "tr##{dom_id(max_muncy)}"
    assert_select "tr##{dom_id(mike_trout)}"
  end

  test "index excludes claimed players" do
    aaron_judge = create(:player, :aaron_judge)
    claimed_player = create(:player, :claimed_player)

    get draft_board_index_url
    assert_response :success

    # Should include unclaimed player
    assert_select "tr##{dom_id(aaron_judge)}"

    # Should not include claimed player even though it has an ESPN rank
    assert_select "tr##{dom_id(claimed_player)}", count: 0
  end

  test "index excludes players without espn_rank" do
    aaron_judge = create(:player, :aaron_judge)
    no_rank_player = create(:player, :no_rank_player)

    get draft_board_index_url
    assert_response :success

    # Should include player with ESPN rank
    assert_select "tr##{dom_id(aaron_judge)}"

    # Should not include player without ESPN rank
    assert_select "tr##{dom_id(no_rank_player)}", count: 0
  end

  test "index orders players by espn_rank ascending" do
    aaron_judge = create(:player, :aaron_judge)
    mike_trout = create(:player, :mike_trout)
    max_muncy = create(:player, :max_muncy_lad)

    get draft_board_index_url
    assert_response :success

    # Check that the response body contains players in the correct order
    response_body = response.body
    aaron_position = response_body.index(dom_id(aaron_judge))
    mike_position = response_body.index(dom_id(mike_trout))
    max_position = response_body.index(dom_id(max_muncy))

    # Verify order: aaron_judge (rank 1), mike_trout (rank 25), max_muncy_lad (rank 150)
    assert aaron_position < mike_position, "Aaron Judge should appear before Mike Trout"
    assert mike_position < max_position, "Mike Trout should appear before Max Muncy"
  end

  test "index returns only players matching all criteria" do
    create(:player, :aaron_judge)
    create(:player, :mike_trout)
    create(:player, :max_muncy_lad)
    claimed_player = create(:player, :claimed_player)
    no_rank_player = create(:player, :no_rank_player)

    get draft_board_index_url
    assert_response :success

    # Should have exactly 3 player rows in the table
    assert_select "tbody tr", count: 3

    # Verify excluded players are not present
    assert_select "tr##{dom_id(claimed_player)}", count: 0
    assert_select "tr##{dom_id(no_rank_player)}", count: 0
  end
end
