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

ActiveRecord::Schema[8.0].define(version: 2025_08_26_143014) do
  create_table "espn_positions", force: :cascade do |t|
    t.string "position", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "espn_positions_players", id: false, force: :cascade do |t|
    t.integer "player_id", null: false
    t.integer "espn_position_id", null: false
    t.index ["espn_position_id", "player_id"], name: "index_espn_positions_players_on_espn_position_id_and_player_id"
    t.index ["player_id", "espn_position_id"], name: "index_espn_positions_players_on_player_id_and_espn_position_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.integer "espn_rank"
    t.integer "cbs_rank"
    t.integer "fantasy_pros_rank"
    t.string "team"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "drafted", default: false, null: false
    t.string "searchable_name"
    t.index ["searchable_name", "team"], name: "index_players_on_searchable_name_and_team", unique: true
  end
end
