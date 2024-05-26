class RemoveRawDataFromBattle < ActiveRecord::Migration[7.1]
  def change
    remove_column :battles, :raw_data
  end
end
