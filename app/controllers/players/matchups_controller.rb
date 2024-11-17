class Players::MatchupsController < Players::BaseController
  include DefaultParams

  before_action :set_default_params

  def performance_group_by_date_chart
    @matchups = MatchupsFilter
      .filter(Matchup, filter_params.with_defaults(character: @player.main_character))
      .performance.group_by_date
    render "matchups/performance_group_by_date_chart"
  end

  private

  def default_params
    {
      played_from: (Date.today - 1.week).to_s,
      played_to: (Date.today).to_s
    }
  end

  def filter_params
    params.permit(:short_id, :character, :control_type, :vs_character,
      :vs_control_type, :played_from, :played_to, :battle_type)
  end
end
