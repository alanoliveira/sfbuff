class DropRawBattleTable < ActiveRecord::Migration[7.1]
  def up
    drop_table :raw_battles
  end

  def down
    create_table "raw_battles", primary_key: "replay_id", id: :string, force: :cascade do |t|
      t.json "data"
      t.index ["replay_id"], name: "index_raw_battles_on_replay_id"
    end
  end
end
