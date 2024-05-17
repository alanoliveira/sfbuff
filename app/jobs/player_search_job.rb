# frozen_string_literal: true

class PlayerSearchJob < ApplicationJob
  include CacheableJob

  queue_as :default

  def perform(term)
    response = BucklerGateway.new.search_players_by_name(term)

    cache(:success, response)
  end
end
