class PlayerSearchJob < ApplicationJob
  include StreamableResultJob

  queue_as :default

  def perform(term)
    fighter_banner_list = FighterBanner.search(term)

    cache_result partial: "fighter_banners/fighter_banner_list", locals: { fighter_banner_list: }
  end
end
