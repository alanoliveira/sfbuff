class CreateSessionEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :session_events do |t|
      t.belongs_to :session, null: false, foreign_key: true
      t.string :name, null: false
      t.json :params
      t.datetime :created_at
    end
  end
end
