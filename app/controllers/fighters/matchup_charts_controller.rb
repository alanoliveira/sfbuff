class Fighters::MatchupChartsController < ApplicationController
  include FighterScoped
  include SetMatchesFilter
  layout "fighter"

  def show
    @matchup_chart = MatchupChart.new(@matches_filter.filter(@fighter.matches))
  end
end
