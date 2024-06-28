class RemoveBattleSubtypeFromBattle < ActiveRecord::Migration[7.1]
  def change
    remove_column :battles, :battle_subtype, :integer
  end
end
