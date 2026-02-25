class CreatePlayerTrackings < ActiveRecord::Migration[8.1]
  def change
    create_table :player_trackings do |t|
      t.references :player, null: false, foreign_key: true, index: { unique: true }
      t.text :notes
      t.boolean :claimed, default: false, null: false

      t.timestamps
    end

    remove_column :players, :claimed, :boolean
  end
end
