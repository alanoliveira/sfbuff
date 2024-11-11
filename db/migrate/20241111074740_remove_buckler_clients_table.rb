class RemoveBucklerClientsTable < ActiveRecord::Migration[7.2]
  def up
    drop_table :buckler_clients
  end

  def down
    create_table :buckler_clients do |t|
      t.string :build_id
      t.string :cookies

      t.timestamps
    end
  end
end
