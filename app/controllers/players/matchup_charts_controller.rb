class Players::MatchupChartsController < Players::BaseController
  def show
    @filter_form = Players::MatchupsFilterForm.new(filter_form_params)
    filled_chart = @player.matchups
      .merge(@filter_form.submit)
      .group(away_challenger: [ :character, :control_type ])
      .select(away_challenger: [ :character, :control_type ])
      .score
      .inject({}, :merge)
    @matchup_chart = blank_chart.merge(filled_chart)
  end

  private

  def blank_chart
    Buckler::Enums::CHARACTERS.values.product(
      Buckler::Enums::CONTROL_TYPES.values
    ).each_with_object({}) do |prod, hash|
      hash[{ "character" => prod[0], "control_type" => prod[1] }] = nil
    end
  end

  def filter_form_params
    params
      .compact_blank
      .with_defaults(played_from:  7.days.ago.to_date,
        played_to: Time.zone.now.to_date, character: @player.main_character)
      .permit(:character, :control_type, :played_from, :played_to, :battle_type)
  end
end
