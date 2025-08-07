module WithDefaultPlayedAtRange
  extend ActiveSupport::Concern

  included do
    before_action :set_default_played_at_range
  end

  private

  def set_default_played_at_range
    params.with_defaults!(
      played_from: (Time.zone.today - 7.days).to_s,
      played_to: Time.zone.today.to_s
    )
  end
end
