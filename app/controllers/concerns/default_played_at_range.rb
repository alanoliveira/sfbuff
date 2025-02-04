module DefaultPlayedAtRange
  extend ActiveSupport::Concern

  included do
    before_action :set_default_played_at_range
  end

  private

  def set_default_played_at_range
    params.with_defaults!(
      played_from: 7.days.ago.to_date,
      played_to: Time.now.to_date,
    )
  end
end
