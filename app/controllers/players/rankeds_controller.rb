class Players::RankedsController < Players::BaseController
  include DefaultParams

  before_action :set_default_params

  def show
    @history = MatchupsFilter.filter(@player.matchups, filter_params)
      .where(battle: Battle.ranked)
      .includes(battle: [ :p1, :p2 ])
      .ordered
  end

  private

  def filter_params
    params.permit(:character, :control_type, :played_from, :played_to)
  end

  def default_params
    {
      played_from: (Date.today - 1.week).to_s,
      played_to: (Date.today).to_s,
      character: @player.main_character
    }
  end
end
