class SynchronizationRequest::ProcessJob < ApplicationJob
  queue_as :default

  def perform(synchronization_request)
    synchronization_request.process!
  end
end
