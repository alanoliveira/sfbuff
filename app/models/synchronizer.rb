class Synchronizer
  attr_reader :short_id, :buckler_client

  def initialize(short_id:, buckler_client: BucklerClient.take)
    @short_id = short_id
    @buckler_client = buckler_client
  end

  def synchronize!
    player = buckler_client.fighter_banner(short_id:).as_player

    new_battles = BattlesSynchronizer.new(player:, buckler_client:).synchronize!
    new_battles.first.try { |it| player.latest_replay_id = it.replay_id }

    player.synchronized_at = Time.zone.now
    player.save!
  end
end
