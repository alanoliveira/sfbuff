class CreateBucklerClients < ActiveRecord::Migration[7.2]
  def change
    create_table :buckler_clients do |t|
      t.string :build_id
      t.string :cookies

      t.timestamps
    end
  end
end
