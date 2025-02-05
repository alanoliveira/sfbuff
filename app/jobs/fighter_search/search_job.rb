class FighterSearch::SearchJob < ApplicationJob
  queue_as :default

  def perform(fighter_search)
    fighter_search.search_now
  end
end
