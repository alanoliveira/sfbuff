class SynchronizationRequest < ApplicationRecord
  belongs_to :session, default: -> { Current.session }
  enum :status, %w[ created processing success failure ], default: "created"
  store_accessor :result, :new_battles_count

  after_save_commit -> { broadcast_replace_later_to session, fighter_id, :synchronization }, if: :finished?

  def finished? = success? || failure?

  def process!
    return unless created? && with_lock { processing! if created? }

    fighter = Fighter.find_or_create_by(id: fighter_id)
    synchronization = fighter.synchronize! || fighter.synchronizations.last
    self.new_battles_count = synchronization.synchronized_battles.count
    success!
  rescue => error
    self.error = error.class.name
    failure!
    raise unless error.is_a? BucklerApiClient::BucklerApiHttpError
  end

  def process_later!
    ProcessJob.perform_later(self)
  end
end
