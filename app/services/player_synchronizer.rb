class PlayerSynchronizer < ApplicationService
  attr_reader :player, :imported_battles_count

  def initialize(player:)
    @player = player
  end

  def run
    player.with_lock do
      synchronize_player!
      synchronize_battles!
      player.synchronized_at = Time.zone.now
      player.save!
    end
  end

  private

  def synchronize_player!
    ProfileSynchronizer.run(player:)
  end

  def synchronize_battles!
    new_battles = BattlesSynchronizer.run(player:)
    @imported_battles_count = new_battles.count
    player.latest_replay_id = new_battles.first.replay_id if new_battles.any?
  end
end
