class CreateFighterSearchProcesses < ActiveRecord::Migration[8.0]
  def change
    create_table :fighter_search_processes do |t|
      t.string :query, null: false
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
