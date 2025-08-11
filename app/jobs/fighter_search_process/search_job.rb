class FighterSearchProcess::SearchJob < ApplicationJob
  include BadGatewayHandleable

  queue_as :default
  limits_concurrency to: 1, key: ->(fighter_search_process) { fighter_search_process.query }, duration: 1.minute

  def perform(fighter_search_process)
    fighter_search_process.search_now!
  end
end
