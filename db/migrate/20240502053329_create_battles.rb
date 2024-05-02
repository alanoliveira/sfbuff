class CreateBattles < ActiveRecord::Migration[7.1]
  def change
    create_table :battles do |t|
      t.integer :battle_type, null: false, index: true
      t.integer :battle_subtype
      t.datetime :played_at, null: false, index: true
      t.string :replay_id, null: false, index: { unique: true }
      t.text :raw_data

      t.timestamps
    end
  end
end
