class MatchupChartJob < ApplicationJob
  include StreamableResultJob

  queue_as :default

  def perform(matchup_filter)
    CurrentMatchupFilter.set(matchup_filter) do
      matchup_chart = MatchupChart.new(CurrentMatchupFilter.matchup)

      ApplicationController.renderer.render_to_string(
        partial: "matchup_charts/matchup_chart",
        locals: { matchup_chart: }
      ).then { cache_result(html: _1) }
    end
  end
end
