class SearchRequest < ApplicationRecord
  enum :status, %w[ created processing success failure ], default: "created"
  attribute :result, :fighter_banner, json_array: true
  alias_attribute :fighter_banners, :result

  after_save_commit -> { broadcast_render_later_to :fighter_search, query }, if: :finished?

  def finished? = success? || failure?

  def process!
    return unless created? && with_lock { processing! if created? }

    fighter_search = FighterSearch.find_or_create_by!(query:)
    fighter_search.refresh!
    self.fighter_banners = fighter_search.fighter_banners
    success!
  rescue => error
    self.error = error.class.name
    failure!
    raise
  end

  def process_later!
    ProcessJob.perform_later(self)
  end
end
