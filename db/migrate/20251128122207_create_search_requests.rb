class CreateSearchRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :search_requests do |t|
      t.string :query, null: false
      t.integer :status, null: false
      t.json :result
      t.string :error

      t.timestamps
    end
  end
end
