# frozen_string_literal: true

class BattlelogImporter
  def initialize(battlelog)
    @battlelog = battlelog
  end

  def import!
    player.with_lock do
      next if player.synchronized?

      save_new_battles!
      update_player!
    end
  end

  private

  def player
    @player ||= Player.find(@battlelog.player_sid)
  end

  def save_new_battles!
    new_battles.each do |battle|
      # it can't be handled on rescue.
      # when pg detect a duplicated register, it throws an error
      # that aborts the transaction
      next if Battle.exists?(replay_id: battle.replay_id)

      battle.save!
    end
  end

  def update_player!
    new_battles.first.try { |b| player.latest_replay_id = b.replay_id }
    player.synchronized_at = Time.current
    player.save!
  end

  def new_battles
    @new_battles ||=
      @battlelog
      .lazy
      .map { |raw| Parsers::BattlelogParser.parse(raw) }
      .take_while { |battle| battle.replay_id != player.latest_replay_id }
      .to_a
  end
end
