class DropSynchronizationRequestsTable < ActiveRecord::Migration[8.1]
  def up
    drop_table :synchronization_requests
  end

  def down
    create_table "synchronization_requests", force: :cascade do |t|
      t.datetime "created_at", null: false
      t.string "error"
      t.bigint "fighter_id", null: false
      t.json "result"
      t.bigint "session_id", null: false
      t.integer "status", null: false
      t.datetime "updated_at", null: false
    end

    add_foreign_key "synchronization_requests", "sessions"
  end
end
