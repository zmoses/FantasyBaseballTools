class RemoveUniqueIndexFromPlayerTrackings < ActiveRecord::Migration[8.1]
  def change
    # Remove unique constraint to allow multiple trackings per player
    # (e.g., when users/leagues are added, each user will have their own tracking per player)
    remove_index :player_trackings, :player_id
    add_index :player_trackings, :player_id
  end
end
