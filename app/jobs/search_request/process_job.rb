class SearchRequest::ProcessJob < ApplicationJob
  queue_as :default

  def perform(search_request)
    search_request.process!
  end
end
