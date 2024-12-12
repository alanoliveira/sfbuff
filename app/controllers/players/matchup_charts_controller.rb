class Players::MatchupChartsController < ApplicationController
  include Players::MatchupScope
  include PlayerScope
  include SetCurrentMatchupFilter

  def show
    @matchup_chart = MatchupChart.new(
      CurrentMatchupFilter.matchup
    )
  end

  def params
    super.with_defaults(
      home_short_id: @player&.short_id&.to_i,
    )
  end
end
