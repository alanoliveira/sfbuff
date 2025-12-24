class FighterSearch::ProcessJob < ApplicationJob
  limits_concurrency to: 1, key: ->(fighter_search) { fighter_search.query }, duration: 1.minute
  queue_as :default

  def perform(fighter_search)
    fighter_search.process
  end
end
