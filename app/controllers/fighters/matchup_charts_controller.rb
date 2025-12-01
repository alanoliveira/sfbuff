class Fighters::MatchupChartsController < ApplicationController
  include FighterScoped
  include SetMatchesFilter
  fresh_when_synchronized_at_changed
  layout "fighter"

  def show
    @matchup_chart = MatchupChart.new(@matches_filter.filter(@fighter.matches))
  end
end
