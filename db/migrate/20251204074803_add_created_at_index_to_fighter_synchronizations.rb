class AddCreatedAtIndexToFighterSynchronizations < ActiveRecord::Migration[8.1]
  def change
    add_index :fighter_synchronizations, :created_at
  end
end
