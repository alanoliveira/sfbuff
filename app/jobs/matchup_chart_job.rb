class MatchupChartJob < ApplicationJob
  include StreamableResultJob

  queue_as :default

  def perform(filter_params)
    matchups = MatchupsFilter.filter(Matchup, filter_params)
    matchup_chart = MatchupChart.from_matchup(matchups)

    cache_result partial: "matchup_charts/matchup_chart_percent", locals: { matchup_chart: }
  end
end
