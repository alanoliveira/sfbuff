class SearchRequest < ApplicationRecord
  belongs_to :session, default: -> { Current.session }
  enum :status, %w[ created processing success failure ], default: "created"

  after_save_commit -> { broadcast_replace_later_to session, :fighter_search, query }, if: :finished?

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
    raise
  end

  def process_later!
    ProcessJob.perform_later(self)
  end
end
