class Fighter::SynchronizeJob < ApplicationJob
  include BucklerServerErrorHandleable

  queue_as :default
  limits_concurrency to: 1, key: ->(fighter) { fighter }, duration: 1.minute

  def perform(fighter)
    fighter.synchronize_now
  end
end
