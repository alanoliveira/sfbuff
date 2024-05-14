class AddNotNullToPlayingCharacterOnChallanger < ActiveRecord::Migration[7.1]
  def change
    change_column_null :challangers, :playing_character, false
  end
end
