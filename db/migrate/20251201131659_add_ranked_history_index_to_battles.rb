class AddRankedHistoryIndexToBattles < ActiveRecord::Migration[8.1]
  def change
    add_index :battles, [ :p1_fighter_id, :p1_character_id, :played_at ], where: "battle_type_id = 1", include: [ "replay_id", "p1_mr", "p1_lp" ]
    add_index :battles, [ :p2_fighter_id, :p2_character_id, :played_at ], where: "battle_type_id = 1", include: [ "replay_id", "p2_mr", "p2_lp" ]
  end
end
