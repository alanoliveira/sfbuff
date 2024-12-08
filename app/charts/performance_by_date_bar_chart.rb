class PerformanceByDateBarChart < ApplicationChart
  def initialize(performance)
    @performance = performance.group_by_date(:played_at).to_a
  end

  def chart_type = "bar"

  def data
    { labels:, datasets: }
  end

  def options
    {
      scales: { x: { stacked: true }, y: { stacked: true } },
      interaction: { mode: "index" }
    }
  end

  def labels
    @performance.map { |group, _| group["date"] }
  end

  def datasets
    win_data, draw_data, lose_data = wdl_data
    [
      { label: I18n.t("attributes.results.win"), backgroundColor: CHART_COLORS[:green], data: win_data },
      { label: I18n.t("attributes.results.draw"), backgroundColor: CHART_COLORS[:yellow], data: draw_data },
      { label: I18n.t("attributes.results.lose"), backgroundColor: CHART_COLORS[:red], data: lose_data }
    ]
  end

  def wdl_data
    @performance.map { |_, score| [ score.win, score.draw, score.lose ] }.transpose
  end
end
