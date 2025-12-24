class AddIndexUniqueUnfinishedSyncOnFighterSynchronizations < ActiveRecord::Migration[8.1]
  def change
    add_index :fighter_synchronizations, :fighter_id, name: "idx_unique_unfinished_synchronization", unique: true, where: "status in (0, 1)"
  end
end
