class BattlesSynchronizer < ApplicationService
  attr_reader :player

  def initialize(player:)
    @player = player
  end

  def run
    BucklerGateway.battles(player.short_id)
      .take_while { _1.replay_id != player.latest_replay_id }
      .to_a
      .each do |battle|
        Battle.transaction(requires_new: true) { battle.save! }
      rescue ActiveRecord::RecordNotUnique
        # ignore, the battle was already imported by the opponent
      end.first.try { player.update(latest_replay_id: _1.replay_id) }
  end
end
