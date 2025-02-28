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

ActiveRecord::Schema[8.0].define(version: 2025_02_28_060232) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.bigint "fighter_id", null: false
    t.integer "character_id", null: false
    t.integer "playing_character_id", null: false
    t.integer "input_type_id", null: false
    t.integer "master_rating"
    t.integer "league_point"
    t.string "name"
    t.json "round_ids", null: false
    t.integer "side", null: false
    t.bigint "battle_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "cached_result"
    t.index ["battle_id"], name: "index_challengers_on_battle_id"
    t.index ["fighter_id", "battle_id"], name: "index_challengers_on_fighter_id_and_battle_id"
  end

  create_table "characters", id: :integer, default: nil, force: :cascade do |t|
    t.string "name"
  end

  create_table "fighters", id: :bigint, default: nil, force: :cascade do |t|
    t.json "profile"
    t.datetime "synchronized_at"
    t.string "last_synchronized_replay_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_view "matchup_caches", materialized: true, sql_definition: <<-SQL
      SELECT battles.battle_type,
      battles.played_at,
      home.fighter_id AS home_fighter_id,
      home.character_id AS home_character_id,
      home.input_type_id AS home_input_type_id,
      away.fighter_id AS away_fighter_id,
      away.character_id AS away_character_id,
      away.input_type_id AS away_input_type_id,
      home.id AS home_challenger_id,
      away.id AS away_challenger_id,
      battles.id AS battle_id
     FROM ((battles
       JOIN challengers home ON ((home.battle_id = battles.id)))
       JOIN challengers away ON (((away.battle_id = battles.id) AND (home.id <> away.id))));
  SQL
  add_index "matchup_caches", ["battle_id", "home_challenger_id", "away_challenger_id"], name: "idx_on_battle_id_home_challenger_id_away_challenger_1a281946be", unique: true
  add_index "matchup_caches", ["home_fighter_id", "played_at"], name: "index_matchup_caches_on_home_fighter_id_and_played_at"

end
