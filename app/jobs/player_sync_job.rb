# frozen_string_literal: true

class PlayerSyncJob < ApplicationJob
  include CacheableJob
  limits_concurrency to: 1, key: ->(player_sid) { player_sid }

  queue_as :default

  def perform(player_sid)
    unless Player.find_by(sid: player_sid).try(&:synchronized?)
      PlayerSynchronizer.new(player_sid:, api: BucklerGateway.new).call
    end
    cache(:success)
  end
end
