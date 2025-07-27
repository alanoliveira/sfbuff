class MigrateBattlesTable < ActiveRecord::Migration[8.0]
  def change
    rename_current_battles
    create_new_battles_table
    migrate_battles_data
    cleanup
  end

  private

  def rename_current_battles
    execute <<-SQL
      ALTER TABLE battles RENAME TO old_battles;
      ALTER SEQUENCE battles_id_seq RENAME TO old_battles_id_seq;
      ALTER INDEX index_battles_on_replay_id RENAME TO index_old_battles_on_replay_id;
    SQL
  end

  def create_new_battles_table
    create_table :battles, id: false do |t|
      t.string "replay_id", null: false, primary_key: true
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
      t.timestamps
    end
  end

  def migrate_battles_data
    execute <<-SQL
      INSERT INTO battles
      SELECT old_battles.replay_id,
             old_battles.played_at,
             old_battles.battle_type battle_type_id,
             CASE p1.cached_result
             WHEN 1 THEN 1
             WHEN -1 THEN 2
             ELSE 0
             END as winner_side,
             p1.fighter_id p1_fighter_id,
             p1.character_id p1_character_id,
             p1.playing_character_id p1_playing_character_id,
             p1.input_type_id p1_input_type_id,
             p1.master_rating p1_mr,
             p1.league_point p1_lp,
             p1.round_ids p1_round_ids,
             p1.name p1_name,
             p2.fighter_id p2_fighter_id,
             p2.character_id p2_character_id,
             p2.playing_character_id p2_playing_character_id,
             p2.input_type_id p2_input_type_id,
             p2.master_rating p2_mr,
             p2.league_point p2_lp,
             p2.round_ids p2_round_ids,
             p2.name p2_name,
             old_battles.created_at,
             NOW()::timestamp(6) updated_at
      FROM old_battles
      INNER JOIN challengers p1 ON p1.battle_id = old_battles.id AND p1.side = 1
      INNER JOIN challengers p2 ON p2.battle_id = old_battles.id AND p2.side = 2;
    SQL
  end

  def cleanup
    execute <<-SQL
      DROP MATERIALIZED VIEW matchup_caches;
      DROP TABLE old_battles;
      DROP TABLE challengers;
      DROP TABLE characters;
    SQL
  end
end
