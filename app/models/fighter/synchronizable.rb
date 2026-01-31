module Fighter::Synchronizable
  extend ActiveSupport::Concern

  included do
    class_attribute :synchronization_interval, instance_writer: false, default: 10.minutes
    has_many :synchronizations, dependent: :destroy
  end

  def synchronizable?
    !synchronized? && !synchronizing?
  end

  def synchronized?
    synchronized_at.try { it.after?(synchronization_interval.ago) }
  end

  def synchronizing?
    current_synchronization.try { !it.finished? }
  end

  def current_synchronization
    synchronizations.last
  end

  def synchronize
    create_synchronization&.tap(&:process)
  end

  def synchronize_later
    create_synchronization&.tap(&:process_later)
  end

  private

  def create_synchronization
    synchronizations.create if synchronizable?
  rescue ActiveRecord::RecordNotUnique
    # there is already an active synchronization
  end
end
