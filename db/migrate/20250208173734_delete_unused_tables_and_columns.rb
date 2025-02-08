class DeleteUnusedTablesAndColumns < ActiveRecord::Migration[8.0]
  def change
    drop_table :player_synchronize_processes
    drop_table :players
    remove_column :challengers, :ranked_variation
    remove_column :battles, :winner_side
  end
end
