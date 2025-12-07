class SearchRequest < ApplicationRecord
  belongs_to :session, default: -> { Current.session }
  enum :status, %w[ created processing success failure ], default: "created"

  validates :query, length: { minimum: 4 }
  normalizes :query, with: ->(query) { query.strip.downcase }

  after_save_commit -> { broadcast_replace_later_to session, :fighter_search }, if: :finished?

  def finished? = success? || failure?

  def process!
    return unless created? && with_lock { processing! if created? }

    fighter_search = FighterSearch.find_or_create_by!(query:)
    fighter_search.refresh!
    self.result = ApplicationController.renderer.render_to_string(fighter_search)
    success!
  rescue => error
    self.error = error.class.name
    failure!
    raise unless error.is_a? BucklerApiClient::BucklerApiHttpError
  end

  def process_later!
    ProcessJob.perform_later(self)
  end
end
