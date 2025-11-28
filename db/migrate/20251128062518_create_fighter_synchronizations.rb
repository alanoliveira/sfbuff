class CreateFighterSynchronizations < ActiveRecord::Migration[8.1]
  def change
    create_table :fighter_synchronizations do |t|
      t.belongs_to :fighter, null: false, foreign_key: true
      t.integer :status, null: false

      t.timestamps
    end
  end
end
