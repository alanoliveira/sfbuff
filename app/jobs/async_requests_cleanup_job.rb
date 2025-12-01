class AsyncRequestsCleanupJob < ApplicationJob
  queue_as :default

  def perform(*args)
    SearchRequest.where("created_at < ?", 1.day.ago).find_in_batches { SearchRequest.where(id: it.map(&:id)).delete_all }
    SynchronizationRequest.where("created_at < ?", 1.day.ago).find_in_batches { SynchronizationRequest.where(id: it.map(&:id)).delete_all }
  end
end
