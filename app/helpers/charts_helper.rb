module ChartsHelper
  def ranked_history_line_chart(ranked_history)
    return no_data_alert unless ranked_history.any?

    render RankedHistoryLineChart.new(ranked_history)
  end

  def performance_by_date_bar_chart(matchup)
    render PerformanceByDateBarChart.new(matchup.performance)
  end
end
