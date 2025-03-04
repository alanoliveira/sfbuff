module Fighter::Synchronizable
  extend ActiveSupport::Concern

  SYNCHRONIZATION_THRESHOLD = 10.minutes

  included do
    after_save_commit :broadcast_replace_header, if: :synchronized_at_previously_changed?
  end

  def synchronization
    [ self, "synchronization" ]
  end

  def synchronized?
    synchronized_at.present? && synchronized_at > SYNCHRONIZATION_THRESHOLD.ago
  end

  def synchronize_now
    Fighter::Synchronizer.new(self).synchronize unless synchronized?
  end

  def synchronize_later(...)
    Fighter::SynchronizeJob.set(...).perform_later(self)
  end
end
