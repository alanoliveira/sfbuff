class AddStatusToBucklerClient < ActiveRecord::Migration[7.2]
  def change
    add_column :buckler_clients, :status, :integer, default: 0
  end
end
