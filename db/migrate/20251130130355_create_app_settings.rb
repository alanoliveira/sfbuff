class CreateAppSettings < ActiveRecord::Migration[8.1]
  def change
    create_table :app_settings do |t|
      t.string :key, null: false
      t.json :value
      t.boolean :encrypted, null: false

      t.timestamps
    end
  end
end
