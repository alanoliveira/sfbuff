class CreateFighterSearches < ActiveRecord::Migration[8.1]
  def change
    create_table :fighter_searches do |t|
      t.string :query, null: false, index: { unique: true }
      t.datetime :performed_at
      t.json :result

      t.timestamps
    end
  end
end
