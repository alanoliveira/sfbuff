class Synchronizer
  attr_reader :short_id, :buckler_bridge

  def initialize(short_id:, buckler_bridge: BucklerBridge.new)
    @short_id = short_id
    @buckler_bridge = buckler_bridge
  end

  def synchronize!
    Player.transaction do
      player = Player.lock.find_or_create_by!(short_id:)
      next if player.synchronized?

      fighter_banner = buckler_bridge.fighter_banner(short_id:)

      battles = new_battles(player.latest_replay_id).to_a
      BattlesSynchronizer.new(battles:).synchronize!

      player.assign_attributes(fighter_banner.attributes.slice("name", "main_character"))
      player.latest_replay_id = battles.first.replay_id if battles.any?
      player.synchronized_at = Time.zone.now
      player.save!
    end
  end

  private

  def new_battles(latest_replay_id)
    buckler_bridge.battle_list(short_id:)
      .take_while { |b| b[:replay_id] != latest_replay_id }
  end
end
