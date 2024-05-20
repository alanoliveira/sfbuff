class RenameChallangersToChallengers < ActiveRecord::Migration[7.1]
  def change
    rename_table :challangers, :challengers
  end
end
