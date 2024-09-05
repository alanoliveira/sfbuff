class Players::MatchupChartsController < ApplicationController
  include PlayerScoped

  layout "players"

  def show
    @filter_form = Players::MatchupChartFilterForm.new(player: @player)
    @filter_form.fill(params)
    @matchup_chart = @filter_form.submit
  end
end
