class ChangeFighterSearchesStructure < ActiveRecord::Migration[8.1]
  def change
    remove_column :fighter_searches, :performed_at, :datetime
    add_column :fighter_searches, :error, :string
    add_column :fighter_searches, :status, :integer
    remove_index :fighter_searches, [ :query ], unique: true
  end
end
