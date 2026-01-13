require "test_helper"

class PlayerTest < ActiveSupport::TestCase
  test "validates uniqueness of searchable_name scoped to team" do
    existing_player = create(:player, :aaron_judge)

    player = Player.new(
      name: "Aaron Judge",
      searchable_name: existing_player.searchable_name,
      team: "NYY"
    )

    assert_not player.valid?
    assert_includes player.errors[:searchable_name], "has already been taken"
  end

  test "allows same searchable_name for different teams" do
    existing_player = create(:player, :max_muncy_lad)

    player = Player.new(
      name: "Max Muncy",
      searchable_name: existing_player.searchable_name,
      team: "OAK"
    )

    assert player.valid?
  end

  test ".searchable_name removes suffixes" do
    assert_equal "johndoe", Player.searchable_name("John Doe Jr.")
    assert_equal "johndoe", Player.searchable_name("John Doe Sr.")
    assert_equal "johndoe", Player.searchable_name("John Doe II")
    assert_equal "johndoe", Player.searchable_name("John Doe III")
    assert_equal "johndoe", Player.searchable_name("John Doe IV")
    assert_equal "johndoe", Player.searchable_name("John Doe V")
  end

  test ".searchable_name converts to lowercase" do
    assert_equal "aaronjudge", Player.searchable_name("Aaron Judge")
    assert_equal "aaronjudge", Player.searchable_name("AARON JUDGE")
  end

  test ".searchable_name replaces hyphens with spaces" do
    assert_equal "martinez", Player.searchable_name("J-D Martinez")
  end

  test ".searchable_name removes special characters" do
    assert_equal "joseramirez", Player.searchable_name("José Ramírez")
  end

  test ".searchable_name removes single character parts" do
    assert_equal "michaeltaylor", Player.searchable_name("Michael A Taylor")
    assert_equal "michaeltaylor", Player.searchable_name("Michael A. Taylor")
  end

  test "#add_position_eligibility adds new position" do
    player = create(:player, :aaron_judge)
    initial_count = player.espn_positions.count

    player.add_position_eligibility("OF")

    assert_equal initial_count + 1, player.espn_positions.count
    assert player.espn_positions.exists?(position: "OF")
  end

  test "#add_position_eligibility does not add duplicate position" do
    player = create(:player, :aaron_judge)
    position = create(:espn_position, :outfield)
    player.espn_positions << position

    initial_count = player.espn_positions.count
    player.add_position_eligibility("OF")

    assert_equal initial_count, player.espn_positions.count
  end

  test ".find_best_match finds player by name only" do
    expected_player = create(:player, :aaron_judge)
    player = Player.find_best_match(name: expected_player.name)
    assert_equal expected_player, player
  end

  test ".find_best_match finds player by name and team" do
    expected_player = create(:player, :max_muncy_lad)
    player = Player.find_best_match(name: expected_player.name, team: "LAD")
    assert_equal expected_player, player
  end

  test ".find_best_match raises UnknownPlayerNameError when no matches found" do
    assert_raises(Player::UnknownPlayerNameError) do
      Player.find_best_match(name: "Nonexistent Player")
    end
  end

  test ".find_best_match falls back to searching without team" do
    # Create a player without setting up position eligibility
    player = create(:player, :aaron_judge)

    # Should find player even if team doesn't match exactly
    found_player = Player.find_best_match(name: player.name, team: "WRONG_TEAM")
    assert_equal player, found_player
  end

  test ".find_best_match with position filters by espn_positions" do
    player = create(:player, :aaron_judge)
    outfield_position = create(:espn_position, :outfield)
    player.espn_positions << outfield_position

    found_player = Player.find_best_match(name: player.name, position: "OF")
    assert_equal player, found_player
  end

  test ".find_best_match falls back to searching without position" do
    player = create(:player, :aaron_judge)

    # Should find player even without position match
    found_player = Player.find_best_match(name: player.name, position: "1B")
    assert_equal player, found_player
  end

  test "has_and_belongs_to_many espn_positions association" do
    player = create(:player, :aaron_judge)
    position = create(:espn_position, :outfield)

    player.espn_positions << position

    assert_includes player.espn_positions, position
    assert_includes position.players, player
  end
end
