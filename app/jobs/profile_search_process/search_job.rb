class ProfileSearchProcess::SearchJob < ApplicationJob
  include BadGatewayHandleable

  queue_as :default
  limits_concurrency to: 1, key: ->(profile_search_process) { profile_search_process.query }, duration: 1.minute

  def perform(profile_search_process)
    profile_search_process.search_now!
  end
end
