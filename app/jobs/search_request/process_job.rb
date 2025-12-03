class SearchRequest::ProcessJob < ApplicationJob
  include RescueFromBucklerApiHttpErrors

  limits_concurrency to: 1, key: ->(search_request) { search_request.query }, duration: 1.minute
  queue_as :default

  def perform(search_request)
    search_request.process!
  end
end
