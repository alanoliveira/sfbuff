class Synchronizer::BattlesSynchronizer
  attr_reader :player, :buckler_client

  def initialize(player:, buckler_client:)
    @player = player
    @buckler_client = buckler_client
  end

  def synchronize!
    new_battles.each do |battle|
      battle.save
    rescue ActiveRecord::RecordNotUnique
      # ignore, the battle was already imported by the opponent
    end
  end

  private

  def new_battles
    @new_battles ||= buckler_client.battle_list(short_id: player.short_id)
      .take_while { |b| b[:replay_id] != player.latest_replay_id }
      .to_a
  end
end
