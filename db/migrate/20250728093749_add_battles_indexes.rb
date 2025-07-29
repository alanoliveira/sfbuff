class AddBattlesIndexes < ActiveRecord::Migration[8.0]
  def change
    add_index :battles, [ :p1_fighter_id, :played_at ]
    add_index :battles, [ :p2_fighter_id, :played_at ]
  end
end
