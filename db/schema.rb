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

ActiveRecord::Schema[7.2].define(version: 2024_08_17_081132) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "battles", force: :cascade do |t|
    t.string "replay_id", null: false
    t.integer "battle_type", null: false
    t.datetime "played_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["battle_type"], name: "index_battles_on_battle_type"
    t.index ["played_at"], name: "index_battles_on_played_at"
    t.index ["replay_id"], name: "index_battles_on_replay_id", unique: true
  end

  create_table "challengers", force: :cascade do |t|
    t.bigint "short_id", null: false
    t.integer "character", null: false
    t.integer "playing_character", null: false
    t.integer "control_type", null: false
    t.integer "master_rating"
    t.integer "league_point"
    t.string "name"
    t.integer "rounds", null: false, array: true
    t.integer "side", null: false
    t.bigint "battle_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["battle_id"], name: "index_challengers_on_battle_id"
    t.index ["character"], name: "index_challengers_on_character"
    t.index ["control_type"], name: "index_challengers_on_control_type"
    t.index ["short_id"], name: "index_challengers_on_short_id"
  end

  create_table "players", force: :cascade do |t|
    t.bigint "short_id", null: false
    t.string "name"
    t.integer "main_character"
    t.string "latest_replay_id"
    t.datetime "synchronized_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["short_id"], name: "index_players_on_short_id"
  end
end
