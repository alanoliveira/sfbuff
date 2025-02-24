class CreateMatchupIndexes < ActiveRecord::Migration[8.0]
  def change
    create_table :matchup_indexes, id: false do |t|
      t.bigint :battle_id, null: false
      t.datetime :played_at, null: false
      t.integer :battle_type, null: false, limit: 1


      t.bigint :home_challenger_id, null: false
      t.bigint :home_fighter_id, null: false
      t.integer :home_character_id, null: false, limit: 1
      t.integer :home_input_type_id, null: false, limit: 1

      t.bigint :away_challenger_id, null: false
      t.bigint :away_fighter_id, null: false
      t.integer :away_character_id, null: false, limit: 1
      t.integer :away_input_type_id, null: false, limit: 1

      t.index [ :home_fighter_id, :played_at ]
      t.index [ :battle_type, :home_fighter_id, :home_character_id ], where: "battle_type = 1"
    end
  end
end
