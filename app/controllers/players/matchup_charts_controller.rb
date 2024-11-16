class Players::MatchupChartsController < Players::BaseController
  include DefaultParams

  before_action :set_default_params

  def show
    matchup = MatchupsFilter.filter(Battle.matchup, filter_params)
    @matchup_chart = MatchupChart.from_matchup(matchup)
  end

  private

  def default_params
    {
      played_from: (Date.today - 1.week).to_s,
      played_to: (Date.today).to_s
    }
  end

  def filter_params
    params.permit(:short_id, :character, :control_type, :played_from, :played_to, :battle_type)
  end
end
