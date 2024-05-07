# frozen_string_literal: true

class PlayerSyncJob < ApplicationJob
  include CacheableJob

  queue_as :default

  def perform(player_sid)
    PlayerSynchronizer.new(player_sid, BucklerGateway.new).synchronize
    cache(:success)
  rescue StandardError => e
    cache(:error, { class: e.class.name, message: e.message })
  end
end
