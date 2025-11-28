class CreateBattles < ActiveRecord::Migration[8.1]
  def change
    create_table :battles do |t|
      t.string :replay_id, null: :false, index: { unique: true }
      t.datetime :played_at, null: false, index: true
      t.integer :battle_type_id, null: false
      t.bigint :p1_fighter_id, null: false
      t.integer :p1_character_id, null: false
      t.integer :p1_playing_character_id, null: false
      t.integer :p1_input_type_id, null: false
      t.integer :p1_mr
      t.integer :p1_lp
      t.json :p1_rounds, null: false
      t.string :p1_name, null: false
      t.bigint :p2_fighter_id, null: false
      t.integer :p2_character_id, null: false
      t.integer :p2_playing_character_id, null: false
      t.integer :p2_input_type_id, null: false
      t.integer :p2_mr
      t.integer :p2_lp
      t.json :p2_rounds, null: false
      t.string :p2_name, null: false

      t.timestamps
    end
  end
end
