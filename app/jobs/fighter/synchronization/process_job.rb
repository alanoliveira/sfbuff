class Fighter::Synchronization::ProcessJob < ApplicationJob
  include RescueFromBucklerApiHttpErrors

  limits_concurrency to: 1, key: ->(fighter_synchronization) { fighter_synchronization.fighter_id }, duration: 1.minute

  queue_as :synchronization

  def perform(fighter_synchronization)
    fighter_synchronization.process
  end
end
