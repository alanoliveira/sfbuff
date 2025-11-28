class CreateSynchronizationRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :synchronization_requests do |t|
      t.bigint :fighter_id, null: false
      t.integer :status, null: false
      t.json :result
      t.string :error

      t.timestamps
    end
  end
end
