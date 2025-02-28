class RefreshMatchupCacheJob < ApplicationJob
  queue_as :default

  def perform
    Matchup::MatchupCache.refresh(concurrently: true)
  end
end
