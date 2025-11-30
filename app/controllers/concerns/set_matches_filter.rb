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
    params.permit(MatchesFilter.attribute_names)
  end
end
