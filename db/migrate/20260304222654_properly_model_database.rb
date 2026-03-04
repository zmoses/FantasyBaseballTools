class ProperlyModelDatabase < ActiveRecord::Migration[8.1]
  def change
    # Players changes:
    # - Rename team -> mlb_team and update the index
    # - Drop rank columns; moving to new LeaguePlayers table below
    remove_index :players, name: "index_players_on_searchable_name_and_team"
    rename_column :players, :team, :mlb_team
    add_index :players, [ :searchable_name, :mlb_team ], unique: true
    remove_column :players, :cbs_rank, :integer
    remove_column :players, :espn_rank, :integer
    remove_column :players, :fantasy_pros_rank, :integer

    # League changes:
    # - Add draft_started_at
    # - Add roster_slots
    add_column :leagues, :draft_started_at, :datetime
    add_column :leagues, :roster_slots, :jsonb, default: {}

    # PlayerTracking changes:
    # - Table renamed to UserPlayers
    # - Dropped claimed column; it's also moving to LeaguePlayers below
    # - Add user_id
    rename_table :player_trackings, :user_players
    remove_column :user_players, :claimed, :boolean, default: false, null: false
    # This will need to be null: false, but with existing data in this table it'll blow up
    # Follow up with another migration after this.
    add_column :user_players, :user_id, :integer
    add_index :user_players, :user_id
    add_foreign_key :user_players, :users

    # LeaguePlayer: new table with enum
    create_enum "roster_status", [ "available", "drafted_by_user", "drafted" ]

    create_table :league_players do |t|
      t.references :league, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true
      t.datetime :ranks_synced_at
      t.jsonb :position_eligibility, default: []
      t.enum :roster_status, enum_type: "roster_status", null: false, default: "available"
      t.jsonb :ranks, default: {}
      t.timestamps
    end
  end
end
