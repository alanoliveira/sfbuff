class AddChallengersIndexOnFighterIdAndCharacterIdAndPlayedAt < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  def change
    add_index :challengers, [ :fighter_id, :character_id, :played_at ], algorithm: :concurrently
  end
end
