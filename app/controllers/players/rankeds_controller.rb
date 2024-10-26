class Players::RankedsController < Players::BaseController
  include DefaultParams

  before_action :set_default_params

  def show
    matchups = MatchupsFilter
      .filter(Battle.ranked.matchup, filter_params)
      .select("home.id challenger_id")

    @history = Challenger
      .with(matchups:).joins(:matchups)
      .joins(:battle).includes(:battle).merge(Battle.ordered)
  end

  private

  def filter_params
    params.permit(:short_id, :character, :control_type, :played_from, :played_to)
  end

  def default_params
    {
      played_from: (Date.today - 1.week).to_s,
      played_to: (Date.today).to_s,
      character: @player.main_character
    }
  end
end
