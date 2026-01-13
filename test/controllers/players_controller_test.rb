require "test_helper"

class PlayersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @player = create(:player, :aaron_judge)
  end

  test "should show player" do
    get player_url(@player)
    assert_response :success
  end
end
