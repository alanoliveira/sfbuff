class CreateFighters < ActiveRecord::Migration[8.1]
  def change
    create_table :fighters, id: :bigint, default: nil do |t|
      t.string :name
      t.integer :main_character_id

      t.timestamps
    end
  end
end
