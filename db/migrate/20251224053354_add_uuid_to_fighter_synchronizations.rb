class AddUuidToFighterSynchronizations < ActiveRecord::Migration[8.1]
  def change
    add_column :fighter_synchronizations, :uuid, :string
  end
end
