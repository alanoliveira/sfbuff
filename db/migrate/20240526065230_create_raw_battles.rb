class CreateRawBattles < ActiveRecord::Migration[7.1]
  def up
    create_table :raw_battles, id: false do |t|
      t.string :replay_id, null: false, index: true, primary_key: true
      t.json :data
    end

    Battle.all.each do |b|
      RawBattle.create(replay_id: b.replay_id, data: JSON.parse(b.raw_data))
    end
  end

  def down
    drop_table :raw_battles
  end
end
