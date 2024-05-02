class CreateBucklerCredentials < ActiveRecord::Migration[7.1]
  def change
    create_table :buckler_credentials, id: false do |t|
      t.jsonb :credentials
    end
  end
end
