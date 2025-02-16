class FighterSearch::SearchJob < ApplicationJob
  queue_as :default
  limits_concurrency to: 1, key: ->(fighter_search) { fighter_search.query }, duration: 1.minute

  def perform(fighter_search)
    fighter_search.search_now
  end
end
