class CreateJoinTableFighterSynchronizationsBattles < ActiveRecord::Migration[8.1]
  def change
    create_join_table :fighter_synchronizations, :battles do |t|
      t.index [ :fighter_synchronization_id, :battle_id ]
      t.index [ :battle_id, :fighter_synchronization_id ]
    end
  end
end
