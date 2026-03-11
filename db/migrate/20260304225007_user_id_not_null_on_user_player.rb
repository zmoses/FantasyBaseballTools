class UserIdNotNullOnUserPlayer < ActiveRecord::Migration[8.1]
  def up
    UserPlayer.where(user_id: nil).delete_all
    change_column_null :user_players, :user_id, false
  end

  def down
    change_column_null :user_players, :user_id, true
  end
end
