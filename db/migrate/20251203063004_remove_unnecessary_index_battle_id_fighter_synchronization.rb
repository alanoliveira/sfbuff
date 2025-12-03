class RemoveUnnecessaryIndexBattleIdFighterSynchronization < ActiveRecord::Migration[8.1]
  def change
    remove_index :battles_fighter_synchronizations, [ "battle_id", "fighter_synchronization_id" ]
  end
end
