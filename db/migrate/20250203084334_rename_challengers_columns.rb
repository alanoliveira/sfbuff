class RenameChallengersColumns < ActiveRecord::Migration[8.0]
  def change
    rename_column :challengers, :character, :character_id
    rename_column :challengers, :playing_character, :playing_character_id
    rename_column :challengers, :control_type, :input_type_id
    rename_column :challengers, :short_id, :fighter_id
    rename_column :challengers, :rounds, :round_ids
  end
end
