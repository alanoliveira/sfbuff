class SynchronizationRequest::ProcessJob < ApplicationJob
  include RescueFromBucklerApiHttpErrors

  limits_concurrency to: 1, key: ->(synchronization_request) { synchronization_request.fighter_id }, duration: 1.minute
  queue_as :default

  def perform(synchronization_request)
    synchronization_request.process
  end
end
