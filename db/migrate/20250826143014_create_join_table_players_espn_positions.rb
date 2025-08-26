class CreateJoinTablePlayersEspnPositions < ActiveRecord::Migration[8.0]
  def change
    create_join_table :players, :espn_positions do |t|
      t.index [ :player_id, :espn_position_id ]
      t.index [ :espn_position_id, :player_id ]
    end
  end
end
