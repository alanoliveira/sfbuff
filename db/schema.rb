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

ActiveRecord::Schema[8.1].define(version: 2025_12_01_131659) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "app_settings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "encrypted", null: false
    t.string "key", null: false
    t.datetime "updated_at", null: false
    t.json "value"
  end

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
    t.integer "winner_side", null: false
    t.index ["p1_fighter_id", "p1_character_id", "played_at"], name: "idx_on_p1_fighter_id_p1_character_id_played_at_e033a5d039", where: "(battle_type_id = 1)", include: ["replay_id", "p1_mr", "p1_lp"]
    t.index ["p2_fighter_id", "p2_character_id", "played_at"], name: "idx_on_p2_fighter_id_p2_character_id_played_at_fedf543a9e", where: "(battle_type_id = 1)", include: ["replay_id", "p2_mr", "p2_lp"]
    t.index ["played_at"], name: "index_battles_on_played_at"
    t.index ["replay_id"], name: "index_battles_on_replay_id", unique: true
  end

  create_table "battles_fighter_synchronizations", id: false, force: :cascade do |t|
    t.bigint "battle_id", null: false
    t.bigint "fighter_synchronization_id", null: false
    t.index ["battle_id", "fighter_synchronization_id"], name: "idx_on_battle_id_fighter_synchronization_id_36a977d833"
    t.index ["fighter_synchronization_id", "battle_id"], name: "idx_on_fighter_synchronization_id_battle_id_e05ed78f24"
  end

  create_table "current_league_infos", force: :cascade do |t|
    t.integer "character_id", null: false
    t.datetime "created_at", null: false
    t.bigint "fighter_id", null: false
    t.integer "lp"
    t.integer "mr"
    t.datetime "updated_at", null: false
    t.index ["fighter_id", "character_id"], name: "index_current_league_infos_on_fighter_id_and_character_id", unique: true
    t.index ["fighter_id"], name: "index_current_league_infos_on_fighter_id"
  end

  create_table "fighter_searches", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "performed_at"
    t.string "query", null: false
    t.json "result"
    t.datetime "updated_at", null: false
    t.index ["query"], name: "index_fighter_searches_on_query", unique: true
  end

  create_table "fighter_synchronizations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "fighter_id", null: false
    t.integer "status", null: false
    t.datetime "updated_at", null: false
    t.index ["fighter_id"], name: "index_fighter_synchronizations_on_fighter_id"
  end

  create_table "fighters", id: :bigint, default: nil, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "main_character_id"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "search_requests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "error"
    t.string "query", null: false
    t.text "result"
    t.bigint "session_id", null: false
    t.integer "status", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "last_active_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_agent"
  end

  create_table "synchronization_requests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "error"
    t.bigint "fighter_id", null: false
    t.json "result"
    t.bigint "session_id", null: false
    t.integer "status", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "current_league_infos", "fighters"
  add_foreign_key "fighter_synchronizations", "fighters"
  add_foreign_key "search_requests", "sessions"
  add_foreign_key "synchronization_requests", "sessions"

  create_view "matches", sql_definition: <<-SQL
      SELECT replay_id,
      played_at,
      battle_type_id,
      home_fighter_id,
      home_character_id,
      home_playing_character_id,
      home_input_type_id,
      home_mr,
      home_lp,
      home_rounds,
      home_name,
      away_fighter_id,
      away_character_id,
      away_playing_character_id,
      away_input_type_id,
      away_mr,
      away_lp,
      away_rounds,
      away_name,
      result
     FROM ( SELECT p1_home_p2_away.replay_id,
              p1_home_p2_away.played_at,
              p1_home_p2_away.battle_type_id,
              p1_home_p2_away.p1_fighter_id AS home_fighter_id,
              p1_home_p2_away.p1_character_id AS home_character_id,
              p1_home_p2_away.p1_playing_character_id AS home_playing_character_id,
              p1_home_p2_away.p1_input_type_id AS home_input_type_id,
              p1_home_p2_away.p1_mr AS home_mr,
              p1_home_p2_away.p1_lp AS home_lp,
              p1_home_p2_away.p1_rounds AS home_rounds,
              p1_home_p2_away.p1_name AS home_name,
              p1_home_p2_away.p2_fighter_id AS away_fighter_id,
              p1_home_p2_away.p2_character_id AS away_character_id,
              p1_home_p2_away.p2_playing_character_id AS away_playing_character_id,
              p1_home_p2_away.p2_input_type_id AS away_input_type_id,
              p1_home_p2_away.p2_mr AS away_mr,
              p1_home_p2_away.p2_lp AS away_lp,
              p1_home_p2_away.p2_rounds AS away_rounds,
              p1_home_p2_away.p2_name AS away_name,
                  CASE p1_home_p2_away.winner_side
                      WHEN 1 THEN 1
                      WHEN 2 THEN '-1'::integer
                      ELSE 0
                  END AS result
             FROM battles p1_home_p2_away
          UNION ALL
           SELECT p2_home_p1_away.replay_id,
              p2_home_p1_away.played_at,
              p2_home_p1_away.battle_type_id,
              p2_home_p1_away.p2_fighter_id AS home_fighter_id,
              p2_home_p1_away.p2_character_id AS home_character_id,
              p2_home_p1_away.p2_playing_character_id AS home_playing_character_id,
              p2_home_p1_away.p2_input_type_id AS home_input_type_id,
              p2_home_p1_away.p2_mr AS home_mr,
              p2_home_p1_away.p2_lp AS home_lp,
              p2_home_p1_away.p2_rounds AS home_rounds,
              p2_home_p1_away.p2_name AS home_name,
              p2_home_p1_away.p1_fighter_id AS away_fighter_id,
              p2_home_p1_away.p1_character_id AS away_character_id,
              p2_home_p1_away.p1_playing_character_id AS away_playing_character_id,
              p2_home_p1_away.p1_input_type_id AS away_input_type_id,
              p2_home_p1_away.p1_mr AS away_mr,
              p2_home_p1_away.p1_lp AS away_lp,
              p2_home_p1_away.p1_rounds AS away_rounds,
              p2_home_p1_away.p1_name AS away_name,
                  CASE p2_home_p1_away.winner_side
                      WHEN 2 THEN 1
                      WHEN 1 THEN '-1'::integer
                      ELSE 0
                  END AS result
             FROM battles p2_home_p1_away) matches;
  SQL
end
