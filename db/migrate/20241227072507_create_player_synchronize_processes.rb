class CreatePlayerSynchronizeProcesses < ActiveRecord::Migration[8.0]
  def change
    create_table :player_synchronize_processes do |t|
      t.bigint :short_id, null: false, index: true
      t.integer :imported_battles_count, default: 0
      t.json :error
      t.datetime :started_at
      t.datetime :finished_at

      t.timestamps
    end
  end
end
