class SessionsCleanupJob < ApplicationJob
  cattr_accessor :deletable_threshold, default: 2.weeks
  queue_as :default

  def perform
    Session.where("last_active_at < ?", deletable_threshold.ago).find_in_batches do |sessions|
      sessions.each(&:destroy)
    end
  end
end
