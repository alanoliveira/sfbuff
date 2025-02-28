class CreateMatchupCaches < ActiveRecord::Migration[8.0]
  def change
    create_view :matchup_caches, materialized: true
    add_index :matchup_caches, [ :home_fighter_id, :played_at ]
    add_index :matchup_caches, [ :battle_id, :home_challenger_id, :away_challenger_id ], unique: true
  end
end
