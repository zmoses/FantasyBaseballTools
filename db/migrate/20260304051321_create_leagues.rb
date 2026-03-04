class CreateLeagues < ActiveRecord::Migration[8.1]
  def change
    create_table :leagues do |t|
      t.string :name
      t.string :scoring_format
      t.integer :player_id
      t.string :platform

      t.timestamps
    end
  end
end
