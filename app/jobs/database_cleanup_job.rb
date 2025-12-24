class DatabaseCleanupJob < ApplicationJob
  queue_as :default

  def perform(*args)
    FighterSearch.where(created_at: ..1.day.ago).find_in_batches { FighterSearch.where(id: it.map(&:id)).delete_all }
  end
end
