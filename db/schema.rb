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

ActiveRecord::Schema[8.1].define(version: 2025_11_28_031959) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "battles", force: :cascade do |t|
    t.integer "battle_type_id", null: false
    t.datetime "created_at", null: false
    t.integer "p1_character_id", null: false
    t.bigint "p1_fighter_id", null: false
    t.integer "p1_input_type_id", null: false
    t.integer "p1_lp"
    t.integer "p1_mr"
    t.string "p1_name", null: false
    t.integer "p1_playing_character_id", null: false
    t.json "p1_rounds", null: false
    t.integer "p2_character_id", null: false
    t.bigint "p2_fighter_id", null: false
    t.integer "p2_input_type_id", null: false
    t.integer "p2_lp"
    t.integer "p2_mr"
    t.string "p2_name", null: false
    t.integer "p2_playing_character_id", null: false
    t.json "p2_rounds", null: false
    t.datetime "played_at", null: false
    t.string "replay_id"
    t.datetime "updated_at", null: false
    t.index ["played_at"], name: "index_battles_on_played_at"
    t.index ["replay_id"], name: "index_battles_on_replay_id", unique: true
  end

  create_table "fighters", id: :bigint, default: nil, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "main_character_id"
    t.string "name"
    t.datetime "updated_at", null: false
  end
end
