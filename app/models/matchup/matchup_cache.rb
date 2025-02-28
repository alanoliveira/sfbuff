class Matchup::MatchupCache < ApplicationRecord
  def self.refresh(concurrently: true)
    Scenic.database.refresh_materialized_view(table_name, concurrently:)
  end
end
