class AddErrorToFighterSynchronizations < ActiveRecord::Migration[8.1]
  def change
    add_column :fighter_synchronizations, :error, :string
  end
end
