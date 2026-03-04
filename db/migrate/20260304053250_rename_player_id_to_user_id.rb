class RenamePlayerIdToUserId < ActiveRecord::Migration[8.1]
  def up
    rename_column :leagues, :player_id, :user_id
  end
end
