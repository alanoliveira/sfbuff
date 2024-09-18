class RemoveIndexBattlesOnPlayedAt < ActiveRecord::Migration[7.2]
  def change
    remove_index :battles, :played_at
  end
end
