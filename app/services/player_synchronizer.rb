# frozen_string_literal: true

class PlayerSynchronizer
  class Error < StandardError; end
  class PlayerNotFoundError < Error; end

  def initialize(**params)
    @player_sid = params[:player_sid]
    @api = params[:api]
  end

  def call
    @player = player_importer.call
    battles = battles_importer.call
    @player.latest_replay_id = battles.first.replay_id if battles.any?
    @player.synchronized_at = Time.current
    @player.save!
  end

  private

  attr_reader :player_sid, :api

  def player_importer
    fighter_banner = api.search_player_by_sid(player_sid)
    raise PlayerNotFoundError if fighter_banner.nil?

    FighterBannerImporter.new(fighter_banner:)
  end

  def battles_importer
    battlelog = api.battlelog(player_sid)
    BattlelogImporter.new(battlelog:, import_condition: lambda { |battle|
      battle.replay_id != @player.latest_replay_id
    })
  end
end
