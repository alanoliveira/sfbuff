# frozen_string_literal: true

class PlayerSynchronizer
  class Error < StandardError; end
  class PlayerNotFoundError < Error; end

  def initialize(player_sid, api)
    @player_sid = player_sid
    @api = api
  end

  def synchronize
    player = player_importer.import!
    battles = battles_importer.import_while! do |b|
      b.replay_id != player.latest_replay_id
    end
    player.latest_replay_id = battles.first.replay_id if battles.any?
    player.synchronized_at = Time.current
    player.save!
  end

  private

  attr_reader :player_sid, :api

  def player_importer
    fighter_banner = api.search_player_by_sid(player_sid)
    raise PlayerNotFoundError if fighter_banner.nil?

    FighterBannerImporter.new(fighter_banner)
  end

  def battles_importer
    battlelog = api.battlelog(player_sid)
    BattlelogImporter.new(battlelog)
  end
end
