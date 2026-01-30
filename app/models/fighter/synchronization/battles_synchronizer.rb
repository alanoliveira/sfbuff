class Fighter::Synchronization::BattlesSynchronizer
  attr_reader :fighter, :synchronized_battles

  def initialize(fighter)
    @fighter = fighter
  end

  def synchronize
    @synchronized_battles = BucklerApiGateway
      .fetch_fighter_replays(fighter.id)
      .take_while { |replay| replay.replay_id != fighter_last_synchronized_replay_id }
      .map { |replay| create_or_find_battle_by_replay(replay)  }
      .entries
  end

  private

  def create_or_find_battle_by_replay(replay)
    Battle.create_or_find_by(replay_id: replay.replay_id) { it.from_replay(replay) }.tap do |battle|
      if battle.previously_new_record?
        Rails.logger.info("[#{self.class.name}] Battle #{battle.replay_id} just imported")
      else
        Rails.logger.info("[#{self.class.name}] Battle #{battle.replay_id} already imported")
      end
    end
  end

  def fighter_last_synchronized_replay_id
    @fighter_last_synchronized_replay_id ||= Fighter::Synchronization
      .where(fighter:)
      .joins(:synchronized_battles)
      .order(played_at: :desc)
      .pick(:replay_id)
  end
end
