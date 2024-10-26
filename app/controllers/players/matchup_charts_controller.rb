class Players::MatchupChartsController < Players::BaseController
  include DefaultParams

  before_action :set_default_params

  def show
    @matchup_chart = MatchupsFilter.filter(Battle.matchup, filter_params)
      .performance
      .group(away: [ :character, :control_type ])
      .score
      .inject(blank_chart, :merge)
  end

  private

  def default_params
    {
      played_from: (Date.today - 1.week).to_s,
      played_to: (Date.today).to_s
    }
  end

  def blank_chart
    Buckler::Enums::CHARACTERS.values.product(
      Buckler::Enums::CONTROL_TYPES.values
    ).each_with_object({}) do |prod, hash|
      hash[{ "character" => prod[0], "control_type" => prod[1] }] = nil
    end
  end

  def filter_params
    params.permit(:short_id, :character, :control_type, :played_from, :played_to, :battle_type)
  end
end
