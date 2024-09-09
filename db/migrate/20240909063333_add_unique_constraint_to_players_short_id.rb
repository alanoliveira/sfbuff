class AddUniqueConstraintToPlayersShortId < ActiveRecord::Migration[7.2]
  def change
    remove_index :players, :short_id
    add_index :players, :short_id, unique: true
  end
end
