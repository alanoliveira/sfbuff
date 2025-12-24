class Fighter::Synchronization::BattlesSynchronizer
  attr_reader :fighter, :synchronized_battles

  def initialize(fighter)
    @fighter = fighter
  end

  def synchronize
    @synchronized_battles = BucklerApiGateway
      .fetch_fighter_replays(fighter.id)
      .map { |replay| Battle.create_or_find_by(replay_id: replay.replay_id) { it.from_replay(replay) } }
      .take_while { it.replay_id != fighter_last_synchronized_replay_id }
      .entries
  end

  private

  def fighter_last_synchronized_replay_id
    @fighter_last_synchronized_replay_id ||= Fighter::Synchronization
      .where(fighter:)
      .joins(:synchronized_battles)
      .order(played_at: :desc)
      .pick(:replay_id)
  end
end
