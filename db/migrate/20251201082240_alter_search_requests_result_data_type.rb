class AlterSearchRequestsResultDataType < ActiveRecord::Migration[8.1]
  def change
    change_column :search_requests, :result, :text
  end
end
