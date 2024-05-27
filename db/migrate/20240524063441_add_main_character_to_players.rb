class AddMainCharacterToPlayers < ActiveRecord::Migration[7.1]
  def change
    add_column :players, :main_character, :integer
  end
end
