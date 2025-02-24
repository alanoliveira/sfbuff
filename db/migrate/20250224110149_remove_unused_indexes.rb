class RemoveUnusedIndexes < ActiveRecord::Migration[8.0]
  def change
    remove_index :challengers, :character_id
    remove_index :challengers, :input_type_id
    remove_index :challengers, :fighter_id
  end
end
