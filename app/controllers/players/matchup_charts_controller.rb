class Players::MatchupChartsController < ApplicationController
  include PlayerScope
  include SetCurrentMatchupFilter

  def show
    @matchup_chart = MatchupChart.new(
      CurrentMatchupFilter.matchup
    )
  end

  def params
    super.with_defaults(
      home_short_id: @player&.short_id,
    )
  end
end
