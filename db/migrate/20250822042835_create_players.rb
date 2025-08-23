class CreatePlayers < ActiveRecord::Migration[8.0]
  def change
    create_table :players do |t|
      t.string :name
      t.integer :espn_rank
      t.integer :cbs_rank
      t.integer :fantasy_pros_rank
      t.string :team

      t.timestamps
    end
  end
end
