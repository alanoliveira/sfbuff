# frozen_string_literal: true

class PlayerSyncJob < ApplicationJob
  include CacheableJob
  limits_concurrency to: 1, key: ->(player_sid) { player_sid }

  queue_as :default

  def perform(player_sid)
    unless Player.find_by(sid: player_sid).try(&:synchronized?)
      PlayerSynchronizer.new(player_sid, BucklerGateway.new).synchronize
    end
    cache(:success)
  end
end
