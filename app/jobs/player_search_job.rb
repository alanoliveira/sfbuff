# frozen_string_literal: true

class PlayerSearchJob < ApplicationJob
  queue_as :default

  def perform(term)
    name_result = BucklerGateway.new.search_players_by_name(term)
    sid_result = BucklerGateway.new.search_player_by_sid(term) if term.match? Buckler::Api::SHORT_ID_REGEX

    broadcast_result('success', [name_result, sid_result].flatten.compact)
  end

  rescue_from(StandardError) do |exception|
    broadcast_result('error', exception)
    raise exception
  end

  private

  def broadcast_result(status, data)
    PlayerSearchChannel.broadcast_to(job_id, status, data)
  end
end
