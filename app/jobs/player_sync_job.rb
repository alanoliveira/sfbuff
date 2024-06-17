# frozen_string_literal: true

class PlayerSyncJob < ApplicationJob
  limits_concurrency to: 1, key: ->(player_sid) { player_sid }

  queue_as :default

  def perform(player_sid)
    unless Player.find_by(sid: player_sid).try(&:synchronized?)
      PlayerSynchronizer.new(player_sid:, api: BucklerGateway.new).call
    end

    broadcast_result('success', nil)
  end

  rescue_from(StandardError) do |exception|
    broadcast_result('error', exception)
    raise exception
  end

  private

  def broadcast_result(status, data)
    PlayerSyncChannel.broadcast_to(job_id, status, data)
  end
end
