class PlayerSearchJob < ApplicationJob
  include StreamableResultJob

  queue_as :default

  def perform(query)
    query = query.strip.downcase
    fighter_banner_list = Rails.cache.fetch([ "FighterBanner#search", query ], expires_in: 10.minutes) { FighterBanner.search(query) }

    cache_result partial: "fighter_banners/fighter_banner_list", locals: { fighter_banner_list: }
  end
end
