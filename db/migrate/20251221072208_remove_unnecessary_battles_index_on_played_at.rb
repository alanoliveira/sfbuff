class RemoveUnnecessaryBattlesIndexOnPlayedAt < ActiveRecord::Migration[8.1]
  def change
    remove_index :battles, :played_at
  end
end
