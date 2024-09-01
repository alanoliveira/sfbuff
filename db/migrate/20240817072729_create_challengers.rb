class CreateChallengers < ActiveRecord::Migration[7.2]
  def change
    create_table :challengers do |t|
      t.bigint :short_id, null: false, index: true
      t.integer :character, null: false, index: true
      t.integer :playing_character, null: false
      t.integer :control_type, null: false, index: true
      t.integer :master_rating
      t.integer :league_point
      t.string :name
      t.integer :rounds, null: false, array: true
      t.integer :side, null: false
      t.belongs_to :battle, index: true

      t.timestamps
    end
  end
end
