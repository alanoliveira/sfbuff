# frozen_string_literal: true

class PlayerSearchJob < ApplicationJob
  include ResultBroadcastable
  include BucklerErrorClassifiable

  queue_as :default

  def perform(term)
    name_result = BucklerGateway.new.search_players_by_name(term)
    sid_result = BucklerGateway.new.search_player_by_sid(term) if term.match? Buckler::Api::SHORT_ID_REGEX

    broadcast_result('success', [name_result, sid_result].flatten.compact)
  end

  private

  def resolve_error_kind(error)
    resolve_buckler_error_kind(error)
  end

  def channel
    PlayerSearchChannel
  end
end
