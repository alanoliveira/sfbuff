class CreateBattles < ActiveRecord::Migration[7.2]
  def change
    create_table :battles do |t|
      t.string :replay_id, null: false, index: { unique: true }
      t.integer :battle_type, null: false, index: true
      t.datetime :played_at, null: false, index: true

      t.timestamps
    end
  end
end
