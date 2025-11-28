class SearchRequest < ApplicationRecord
  enum :status, %w[ created processing success failure ], default: "created"

  after_save_commit -> { broadcast_render_later_to :fighter_search, query }, if: :finished?

  def finished? = success? || failure?

  def process!
    return unless created? && with_lock { processing! if created? }

    fighter_search = FighterSearch.find_or_create_by!(query:)
    fighter_search.refresh!
    self.result = fighter_search.result
    success!
  rescue => error
    self.error = error.class.name
    failure!
    raise
  end

  def process_later!
    ProcessJob.perform_later(self)
  end

  def fighter_banners
    Array(result).map { BucklerApiGateway::Mappers::FighterBanner.new it }
  end
end
