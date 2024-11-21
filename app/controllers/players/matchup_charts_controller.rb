class Players::MatchupChartsController < Players::BaseController
  include ParamsWithDefaultPlayedAtRange

  def show
    matchup = MatchupsFilter.filter(Matchup, filter_params)
    @matchup_chart = MatchupChart.from_matchup(matchup)
  end

  private

  def filter_params
    params.permit(:short_id, :character, :control_type, :played_from, :played_to, :battle_type)
  end
end
