class PlayerSearchJob < ApplicationJob
  include StreamableResultJob

  queue_as :default

  def perform(query)
    fighter_banner_list = FighterBanner.search(query)

    cache_result partial: "fighter_banners/fighter_banner_list", locals: { fighter_banner_list: }
  end
end
