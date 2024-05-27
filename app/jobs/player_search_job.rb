# frozen_string_literal: true

class PlayerSearchJob < ApplicationJob
  include CacheableJob

  queue_as :default

  def perform(term)
    response = BucklerGateway.new.search_players_by_name(term)
    if term.match? Buckler::Api::SHORT_ID_REGEX
      sid_response = BucklerGateway.new.search_player_by_sid(term)
      response << sid_response if sid_response.present?
    end

    cache(:success, response)
  end
end
