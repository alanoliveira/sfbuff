class AddChallengersIndexOnFighterIdAndBattleId < ActiveRecord::Migration[8.0]
  def change
    add_index :challengers, [ :fighter_id, :battle_id ]
  end
end
