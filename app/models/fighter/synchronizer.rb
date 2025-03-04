class Fighter::Synchronizer
  attr_reader :fighter, :synchronized_battles_count

  def initialize(fighter)
    @fighter = fighter
  end

  def synchronize
    synchronize_profile
    synchronize_battles
    fighter.update!(synchronized_at: Time.now)
  ensure broadcast_response
  end

  private

  def broadcast_response
    fighter.broadcast_render_to [ fighter, "synchronization" ],
      template: "fighters/synchronizer/response", locals: { synchronizer: self }
  end

  def synchronize_profile
    sync = ProfileSynchronizer.new(fighter)
    sync.synchronize
  end

  def synchronize_battles
    sync = BattlesSynchronizer.new(fighter)
    @synchronized_battles_count = sync.synchronize
  end
end
