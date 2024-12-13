class Players::MatchupChartsController < ApplicationController
  include Players::MatchupScope
  include PlayerScope
  include SetCurrentMatchupFilter

  def show
    @matchup_chart = MatchupChart.new(CurrentMatchupFilter.matchup).then do |matchup_chart|
      cache(matchup_chart) { matchup_chart.tap(&:load) }
    end
  end
end
