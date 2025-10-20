class ChangePlayerDraftedToClaimed < ActiveRecord::Migration[8.0]
  def change
    rename_column :players, :drafted, :claimed
  end
end
