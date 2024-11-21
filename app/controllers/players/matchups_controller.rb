class Players::MatchupsController < Players::BaseController
  include ParamsWithDefaultPlayedAtRange

  def performance_group_by_date_chart
    @matchups = MatchupsFilter
      .filter(Matchup, filter_params)
      .performance.group_by_date
    render "matchups/performance_group_by_date_chart"
  end

  private

  def filter_params
    params.permit(:short_id, :character, :control_type, :vs_character,
      :vs_control_type, :played_from, :played_to, :battle_type)
  end
end
