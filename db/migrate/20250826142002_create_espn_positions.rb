class CreateEspnPositions < ActiveRecord::Migration[8.0]
  def change
    create_table :espn_positions do |t|
      t.string :position, null: false
      t.timestamps
    end
  end
end
