# frozen_string_literal: true

class PlayerSearchJob < ApplicationJob
  include CacheableJob

  queue_as :default

  def perform(term)
    response = BucklerGateway.new.search_players_by_name(term)

    cache(:success, response)
  rescue StandardError => e
    cache(:error, { class: e.class.name, message: e.message })
  end
end
