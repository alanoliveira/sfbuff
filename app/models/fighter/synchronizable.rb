module Fighter::Synchronizable
  extend ActiveSupport::Concern

  included do
    class_attribute :synchronization_interval, instance_writer: false, default: 10.minutes
    has_many :synchronizations, dependent: :destroy
  end

  def synchronizing?
    synchronizations.last.try { !it.finished? }
  end

  def synchronized?
    synchronized_at.try { it.after?(synchronization_interval.ago) }
  end

  def synchronizable?
    !synchronized? && !synchronizing?
  end

  def synchronized_at
    last_success_synchronization.try(&:created_at)
  end

  def last_success_synchronization
    synchronizations.success.last
  end

  def synchronize!(force: false)
    return unless synchronizable? || force
    synchronizations.create.tap(&:process!)
  end
end
