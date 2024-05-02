class CreatePlayers < ActiveRecord::Migration[7.1]
  def change
    create_table :players, id: false do |t|
      t.numeric :sid, null: false, index: true, precision: 20, scale: 0, primary_key: true
      t.string :name
      t.string :latest_replay_id

      t.datetime :synchronized_at
      t.timestamps
    end
  end
end
