class RemoveResultFromChallengers < ActiveRecord::Migration[7.2]
  def change
    remove_column :challengers, :result
  end
end
