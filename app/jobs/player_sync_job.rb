# frozen_string_literal: true

class PlayerSyncJob < ApplicationJob
  include ResultBroadcastable
  include BucklerErrorClassifiable

  limits_concurrency to: 1, key: ->(player_sid) { player_sid }

  queue_as :default

  def perform(player_sid)
    unless Player.find_by(sid: player_sid).try(&:synchronized?)
      PlayerSynchronizer.new(player_sid:, api: BucklerGateway.new).call
    end

    broadcast_result('success', nil)
  end

  private

  def resolve_error_kind(error)
    resolve_buckler_error_kind(error)
  end

  def channel
    PlayerSyncChannel
  end
end
