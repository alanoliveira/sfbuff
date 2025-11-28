class FighterSynchronization < ApplicationRecord
  enum :status, %w[ created processing success failure ], default: "created"
  has_and_belongs_to_many :synchronized_battles, class_name: "Battle"
  belongs_to :fighter

  def process!
    return unless created? && with_lock { processing! if created? }
    synchronize_battles!
    synchronize_fighter!
    success!
  rescue
    failure!
    raise
  end

  private

  def synchronize_battles!
    self.synchronized_battles = BucklerApiGateway
      .fetch_fighter_replays(fighter.id)
      .map { |replay| Battle.create_or_find_by(replay_id: replay.replay_id) { it.from_replay(replay) } }
      .take_while { it.replay_id != fighter_last_synchronized_replay_id }
      .entries
  end

  def synchronize_fighter!
    play_profile = BucklerApiGateway.fetch_fighter_play_profile(fighter.id)
    fighter.from_fighter_banner(play_profile.fighter_banner).save
  end

  def fighter_last_synchronized_replay_id
    FighterSynchronization
      .where(fighter:)
      .joins(:synchronized_battles)
      .order(played_at: :desc)
      .pick(:replay_id)
  end
end
