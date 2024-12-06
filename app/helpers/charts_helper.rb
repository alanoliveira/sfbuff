module ChartsHelper
  def ranked_history_line_chart(ranked_history)
    render RankedHistoryLineChart.new(ranked_history)
  end
end
