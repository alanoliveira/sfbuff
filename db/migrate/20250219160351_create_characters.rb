class CreateCharacters < ActiveRecord::Migration[8.0]
  def change
    create_table :characters, id: :integer, default: nil do |t|
      t.string :name
    end
  end
end
