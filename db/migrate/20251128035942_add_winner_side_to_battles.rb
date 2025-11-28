class AddWinnerSideToBattles < ActiveRecord::Migration[8.1]
  def change
    add_column :battles, :winner_side, :integer, null: false
  end
end
