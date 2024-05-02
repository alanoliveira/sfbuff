class CreateChallangers < ActiveRecord::Migration[7.1]
  def change
    create_table :challangers do |t|
      t.numeric :player_sid, null: false, index: true, precision: 20, scale: 0
      t.integer :character, null: false, index: true
      t.integer :control_type, null: false, index: true
      t.integer :master_rating
      t.integer :league_point
      t.integer :side
      t.string :name
      t.integer :rounds, null: false, array: true
      t.belongs_to :battle, index: true

      t.timestamps
    end
  end
end
