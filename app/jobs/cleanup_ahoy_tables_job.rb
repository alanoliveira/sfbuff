class CleanupAhoyTablesJob < ApplicationJob
  queue_as :default

  def perform
    Ahoy::Visit.where("started_at < ?", 2.weeks.ago).find_in_batches do |visits|
      visit_ids = visits.map(&:id)
      Ahoy::Event.where(visit_id: visit_ids).delete_all
      Ahoy::Visit.where(id: visit_ids).delete_all
    end
  end
end
