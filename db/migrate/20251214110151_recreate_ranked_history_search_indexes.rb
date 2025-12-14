class RecreateRankedHistorySearchIndexes < ActiveRecord::Migration[8.1]
  def up
    add_index "battles", [ "p1_fighter_id", "p1_character_id", "played_at" ], name: "idx_ranked_history_p1", where: "(battle_type_id = 1)"
    add_index "battles", [ "p2_fighter_id", "p2_character_id", "played_at" ], name: "idx_ranked_history_p2", where: "(battle_type_id = 1)"

    remove_index "battles", name: "idx_on_p1_fighter_id_p1_character_id_played_at_e033a5d039"
    remove_index "battles", name: "idx_on_p2_fighter_id_p2_character_id_played_at_fedf543a9e"
  end

  def down
    add_index "battles", [ "p1_fighter_id", "p1_character_id", "played_at" ], name: "idx_on_p1_fighter_id_p1_character_id_played_at_e033a5d039", where: "(battle_type_id = 1)", include: [ "replay_id", "p1_mr", "p1_lp" ]
    add_index "battles", [ "p2_fighter_id", "p2_character_id", "played_at" ], name: "idx_on_p2_fighter_id_p2_character_id_played_at_fedf543a9e", where: "(battle_type_id = 1)", include: [ "replay_id", "p2_mr", "p2_lp" ]

    remove_index "battles", name: "idx_ranked_history_p1"
    remove_index "battles", name: "idx_ranked_history_p2"
  end
end
