class CreateBucklerCredentials < ActiveRecord::Migration[8.0]
  def change
    create_table :buckler_credentials do |t|
      t.string :auth_cookie
      t.string :build_id

      t.timestamps
    end
  end
end
