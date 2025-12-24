module Fighter::Synchronizable
  extend ActiveSupport::Concern

  included do
    class_attribute :synchronization_interval, instance_writer: false, default: 10.minutes
    has_many :synchronizations, dependent: :destroy
  end

  def synchronizable?
    !synchronizing? && !synchronized?
  end

  def synchronizing?
    synchronizations.last.try { !it.finished? }
  end

  def synchronized?
    synchronized_at.try { it.after?(synchronization_interval.ago) }
  end

  def synchronize
    create_synchronization&.tap(&:process)
  end

  private

  def create_synchronization
    synchronizations.create if synchronizable?
  rescue PG::UniqueViolation
    # there is already and active synchronization
  end
end
