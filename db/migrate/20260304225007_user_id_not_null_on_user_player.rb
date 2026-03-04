class UserIdNotNullOnUserPlayer < ActiveRecord::Migration[8.1]
  def change
    change_column_null :user_players, :user_id, false
  end
end
