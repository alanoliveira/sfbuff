class AddWinnerSideToBattle < ActiveRecord::Migration[7.2]
  def change
    add_column :battles, :winner_side, :integer
  end
end
