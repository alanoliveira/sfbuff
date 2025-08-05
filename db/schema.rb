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

ActiveRecord::Schema[8.0].define(version: 2025_08_05_093503) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pg_stat_statements"

  create_table "ahoy_events", force: :cascade do |t|
    t.bigint "visit_id"
    t.bigint "user_id"
    t.string "name"
    t.text "properties"
    t.datetime "time"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time"
    t.index ["user_id"], name: "index_ahoy_events_on_user_id"
    t.index ["visit_id"], name: "index_ahoy_events_on_visit_id"
  end

  create_table "ahoy_visits", force: :cascade do |t|
    t.string "visit_token"
    t.string "visitor_token"
    t.bigint "user_id"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.string "referring_domain"
    t.text "landing_page"
    t.string "browser"
    t.string "os"
    t.string "device_type"
    t.string "country"
    t.datetime "started_at"
    t.index ["user_id"], name: "index_ahoy_visits_on_user_id"
    t.index ["visit_token"], name: "index_ahoy_visits_on_visit_token", unique: true
    t.index ["visitor_token", "started_at"], name: "index_ahoy_visits_on_visitor_token_and_started_at"
  end

  create_table "battles", primary_key: "replay_id", id: :string, force: :cascade do |t|
    t.datetime "played_at", null: false
    t.integer "battle_type_id", null: false
    t.integer "winner_side", null: false
    t.bigint "p1_fighter_id", null: false
    t.integer "p1_character_id", null: false
    t.integer "p1_playing_character_id", null: false
    t.integer "p1_input_type_id", null: false
    t.integer "p1_mr"
    t.integer "p1_lp"
    t.json "p1_round_ids", null: false
    t.string "p1_name", null: false
    t.bigint "p2_fighter_id", null: false
    t.integer "p2_character_id", null: false
    t.integer "p2_playing_character_id", null: false
    t.integer "p2_input_type_id", null: false
    t.integer "p2_mr"
    t.integer "p2_lp"
    t.json "p2_round_ids", null: false
    t.string "p2_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["p1_fighter_id", "played_at"], name: "index_battles_on_p1_fighter_id_and_played_at"
    t.index ["p2_fighter_id", "played_at"], name: "index_battles_on_p2_fighter_id_and_played_at"
  end

  create_table "buckler_credentials", force: :cascade do |t|
    t.string "auth_cookie"
    t.string "build_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fighters", id: :bigint, default: nil, force: :cascade do |t|
    t.json "profile"
    t.datetime "synchronized_at"
    t.string "last_synchronized_replay_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_view "matchups", sql_definition: <<-SQL
      SELECT unnamed_subquery.replay_id,
      unnamed_subquery.played_at,
      unnamed_subquery.battle_type_id,
      unnamed_subquery.home_fighter_id,
      unnamed_subquery.home_character_id,
      unnamed_subquery.home_playing_character_id,
      unnamed_subquery.home_input_type_id,
      unnamed_subquery.home_mr,
      unnamed_subquery.home_lp,
      unnamed_subquery.home_round_ids,
      unnamed_subquery.home_name,
      unnamed_subquery.away_fighter_id,
      unnamed_subquery.away_character_id,
      unnamed_subquery.away_playing_character_id,
      unnamed_subquery.away_input_type_id,
      unnamed_subquery.away_mr,
      unnamed_subquery.away_lp,
      unnamed_subquery.away_round_ids,
      unnamed_subquery.away_name,
      unnamed_subquery.result
     FROM ( SELECT battles.replay_id,
              battles.played_at,
              battles.battle_type_id,
              battles.p1_fighter_id AS home_fighter_id,
              battles.p1_character_id AS home_character_id,
              battles.p1_playing_character_id AS home_playing_character_id,
              battles.p1_input_type_id AS home_input_type_id,
              battles.p1_mr AS home_mr,
              battles.p1_lp AS home_lp,
              battles.p1_round_ids AS home_round_ids,
              battles.p1_name AS home_name,
              battles.p2_fighter_id AS away_fighter_id,
              battles.p2_character_id AS away_character_id,
              battles.p2_playing_character_id AS away_playing_character_id,
              battles.p2_input_type_id AS away_input_type_id,
              battles.p2_mr AS away_mr,
              battles.p2_lp AS away_lp,
              battles.p2_round_ids AS away_round_ids,
              battles.p2_name AS away_name,
                  CASE battles.winner_side
                      WHEN 1 THEN 1
                      WHEN 2 THEN '-1'::integer
                      ELSE 0
                  END AS result
             FROM battles) unnamed_subquery
  UNION ALL
   SELECT battles.replay_id,
      battles.played_at,
      battles.battle_type_id,
      battles.p2_fighter_id AS home_fighter_id,
      battles.p2_character_id AS home_character_id,
      battles.p2_playing_character_id AS home_playing_character_id,
      battles.p2_input_type_id AS home_input_type_id,
      battles.p2_mr AS home_mr,
      battles.p2_lp AS home_lp,
      battles.p2_round_ids AS home_round_ids,
      battles.p2_name AS home_name,
      battles.p1_fighter_id AS away_fighter_id,
      battles.p1_character_id AS away_character_id,
      battles.p1_playing_character_id AS away_playing_character_id,
      battles.p1_input_type_id AS away_input_type_id,
      battles.p1_mr AS away_mr,
      battles.p1_lp AS away_lp,
      battles.p1_round_ids AS away_round_ids,
      battles.p1_name AS away_name,
          CASE battles.winner_side
              WHEN 2 THEN 1
              WHEN 1 THEN '-1'::integer
              ELSE 0
          END AS result
     FROM battles;
  SQL
end
