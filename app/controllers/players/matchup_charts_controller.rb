class Players::MatchupChartsController < Players::BaseController
  include DefaultParams

  before_action :set_default_params

  def show
    filled_chart = MatchupsFilter.filter(@player.matchups, filter_params)
      .group(away_challenger: [ :character, :control_type ])
      .select(away_challenger: [ :character, :control_type ])
      .score
      .inject({}, :merge)
    @matchup_chart = blank_chart.merge(filled_chart)
  end

  private

  def default_params
    {
      played_from:  7.days.ago.to_date,
      played_to: Time.zone.now.to_date
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
    params.permit(:character, :control_type, :played_from, :played_to, :battle_type)
  end
end
