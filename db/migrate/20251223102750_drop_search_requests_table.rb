class DropSearchRequestsTable < ActiveRecord::Migration[8.1]
  def up
    drop_table :search_requests
  end

  def down
    create_table "search_requests", force: :cascade do |t|
      t.datetime "created_at", null: false
      t.string "error"
      t.string "query", null: false
      t.text "result"
      t.bigint "session_id", null: false
      t.integer "status", null: false
      t.datetime "updated_at", null: false
    end
    add_foreign_key "search_requests", "sessions"
  end
end
