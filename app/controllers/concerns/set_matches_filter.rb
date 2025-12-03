module SetMatchesFilter
  extend ActiveSupport::Concern

  included do
    before_action :set_matches_filter
  end

  private

  def set_matches_filter
    @matches_filter = MatchesFilter.new(matches_filter_params)
  end

  def matches_filter_params
    params
      .permit(MatchesFilter.attribute_names)
      .compact_blank
      .with_defaults(
        "played_from" => (Time.zone.today - 7.days).to_date,
        "played_to" => Time.zone.today.to_date
      )
  end
end
