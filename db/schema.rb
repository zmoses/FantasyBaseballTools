# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_03_04_225007) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "platforms", ["Fantrax", "ESPN"]
  create_enum "roster_status", ["available", "drafted_by_user", "drafted"]
  create_enum "scoring_format", ["points", "categories"]

  create_table "espn_positions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "position", null: false
    t.datetime "updated_at", null: false
  end

  create_table "espn_positions_players", id: false, force: :cascade do |t|
    t.integer "espn_position_id", null: false
    t.integer "player_id", null: false
    t.index ["espn_position_id", "player_id"], name: "index_espn_positions_players_on_espn_position_id_and_player_id"
    t.index ["player_id", "espn_position_id"], name: "index_espn_positions_players_on_player_id_and_espn_position_id"
  end

  create_table "league_players", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "league_id", null: false
    t.bigint "player_id", null: false
    t.jsonb "position_eligibility", default: []
    t.jsonb "ranks", default: {}
    t.datetime "ranks_synced_at"
    t.enum "roster_status", default: "available", null: false, enum_type: "roster_status"
    t.datetime "updated_at", null: false
    t.index ["league_id"], name: "index_league_players_on_league_id"
    t.index ["player_id"], name: "index_league_players_on_player_id"
  end

  create_table "leagues", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "draft_started_at"
    t.string "name"
    t.enum "platform", default: "Fantrax", null: false, enum_type: "platforms"
    t.jsonb "roster_slots", default: {}
    t.enum "scoring_format", default: "points", null: false, enum_type: "scoring_format"
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "players", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "mlb_team"
    t.string "name"
    t.string "searchable_name"
    t.datetime "updated_at", null: false
    t.index ["searchable_name", "mlb_team"], name: "index_players_on_searchable_name_and_mlb_team", unique: true
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "user_players", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "notes"
    t.integer "player_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["player_id"], name: "index_user_players_on_player_id"
    t.index ["user_id"], name: "index_user_players_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "league_players", "leagues"
  add_foreign_key "league_players", "players"
  add_foreign_key "sessions", "users"
  add_foreign_key "user_players", "players"
  add_foreign_key "user_players", "users"
end
