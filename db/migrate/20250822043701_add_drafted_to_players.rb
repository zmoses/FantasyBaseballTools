class AddDraftedToPlayers < ActiveRecord::Migration[8.0]
  def change
    add_column :players, :drafted, :boolean, default: false, null: false
  end
end
