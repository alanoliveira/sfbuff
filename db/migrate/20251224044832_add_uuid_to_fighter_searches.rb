class AddUuidToFighterSearches < ActiveRecord::Migration[8.1]
  def change
    add_column :fighter_searches, :uuid, :string
    add_index :fighter_searches, :uuid
  end
end
