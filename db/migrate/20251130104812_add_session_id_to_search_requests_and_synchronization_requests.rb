class AddSessionIdToSearchRequestsAndSynchronizationRequests < ActiveRecord::Migration[8.1]
  def change
    add_column :synchronization_requests, :session_id, :bigint, null: false
    add_column :search_requests, :session_id, :bigint, null: false
    add_foreign_key :synchronization_requests, :sessions
    add_foreign_key :search_requests, :sessions
  end
end
