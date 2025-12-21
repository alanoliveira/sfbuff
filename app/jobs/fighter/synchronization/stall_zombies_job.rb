class Fighter::Synchronization::StallZombiesJob < ApplicationJob
  class_attribute :zombie_threshold, instance_writer: false, default: 3.minutes

  queue_as :default

  def perform
    Fighter::Synchronization.unfinished.where(created_at: ..zombie_threshold.ago).find_each(&:stall!)
  end
end
