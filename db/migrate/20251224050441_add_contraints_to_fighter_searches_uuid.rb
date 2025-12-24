class AddContraintsToFighterSearchesUuid < ActiveRecord::Migration[8.1]
  def up
    execute("delete from fighter_searches where uuid is null")
    remove_index :fighter_searches, :uuid
    add_index :fighter_searches, :uuid, unique: true
  end

  def down
    execute("delete from fighter_searches")
    remove_index :fighter_searches, :uuid
    add_index :fighter_searches, :uuid
  end
end
