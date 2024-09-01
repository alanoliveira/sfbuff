class CreatePlayers < ActiveRecord::Migration[7.2]
  def change
    create_table :players do |t|
      t.bigint :short_id, null: false, index: true
      t.string :name
      t.integer :main_character
      t.string :latest_replay_id
      t.datetime :synchronized_at

      t.timestamps
    end
  end
end
