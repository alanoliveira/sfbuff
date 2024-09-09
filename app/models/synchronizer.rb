class Synchronizer
  attr_reader :short_id, :buckler

  def initialize(short_id:, buckler: Buckler.new)
    @short_id = short_id
    @buckler = buckler
  end

  def synchronize!
    fighter_banner = buckler.fighter_banner(short_id:)
    player = Player.find_or_create_by!(short_id:)

    battles = new_battles(player.latest_replay_id).to_a
    BattlesSynchronizer.new(battles:).synchronize!

    player.assign_attributes(fighter_banner.player_attributes)
    player.latest_replay_id = battles.first.replay_id if battles.any?
    player.synchronized_at = Time.zone.now
    player.save!
  end

  private

  def new_battles(latest_replay_id)
    buckler.battle_list(short_id:)
      .take_while { |b| b[:replay_id] != latest_replay_id }
  end
end
