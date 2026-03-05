require "test_helper"

class LeaguePlayersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @league_player = league_players(:one)
  end

  test "should get index" do
    get league_players_url
    assert_response :success
  end

  test "should get new" do
    get new_league_player_url
    assert_response :success
  end

  test "should create league_player" do
    assert_difference("LeaguePlayer.count") do
      post league_players_url, params: { league_player: {} }
    end

    assert_redirected_to league_player_url(LeaguePlayer.last)
  end

  test "should show league_player" do
    get league_player_url(@league_player)
    assert_response :success
  end

  test "should get edit" do
    get edit_league_player_url(@league_player)
    assert_response :success
  end

  test "should update league_player" do
    patch league_player_url(@league_player), params: { league_player: {} }
    assert_redirected_to league_player_url(@league_player)
  end

  test "should destroy league_player" do
    assert_difference("LeaguePlayer.count", -1) do
      delete league_player_url(@league_player)
    end

    assert_redirected_to league_players_url
  end
end
