class Synchronizer
  attr_reader :short_id, :buckler

  def initialize(short_id:, buckler: Buckler.new)
    @short_id = short_id
    @buckler = buckler
  end

  def synchronize!
    player = buckler.fighter_banner(short_id:).as_player

    new_battles = BattlesSynchronizer.new(player:, buckler:).synchronize!
    new_battles.first.try { |it| player.latest_replay_id = it.replay_id }

    player.synchronized_at = Time.zone.now
    player.save!
  end
end
