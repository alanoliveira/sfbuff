class RankedHistoryLineChart < ApplicationChart
  def initialize(ranked_history)
    @ranked_history = ranked_history
  end

  def chart_type = "line"

  def data
    { datasets: }
  end

  def options
    {
      layout: { padding: { left: 30 } },
      plugins: {
        title: { text: chart_title },
        legend: { display: false },
        tooltip: { displayColors: false },
        marks: {
          "lp" => LeaguePoint::LEAGUE_THRESHOLD.to_h { |points, name| [ points, { title: name.upcase } ] }
        },
        visit: {
          targets: @ranked_history.map { { url: Rails.application.routes.url_helpers.battle_path(_1[:replay_id]), options: { frame: "turbo-modal" } } }
        }
      },
      scales:
    }
  end

  def scales
    {}.tap do
      _1[:lp] = { stack: "ranked", offset: true } if lp_data.any?
      _1[:mr] = { stack: "ranked", stackWeight: 4, offset: true } if mr_data.any?
    end
  end

  def datasets
    [].tap do
      _1 << { tension: 0.4, data: lp_data, yAxisID: "lp", borderColor: CHART_COLORS[:red],
        backgroundColor: CHART_COLORS[:red] } if lp_data.any?
      _1 << { tension: 0.4, data: mr_data, yAxisID: "mr", borderColor: CHART_COLORS[:blue],
        backgroundColor: CHART_COLORS[:blue] } if mr_data.any?
    end
  end

  def mr_data
    @mr_data ||= @ranked_history.filter { _1[:league_point].master? }.filter_map do |item|
      next if item[:master_rating].zero?

      {
        y: item[:master_rating] + item[:mr_variation].to_i,
        x: I18n.localize(item[:played_at], format: :short),
        label: format_label(item[:master_rating], item[:mr_variation])
      }
    end
  end

  def lp_data
    @lp_data ||= @ranked_history.reject { _1[:league_point].master? }.filter_map do |item|
      next if item[:league_point].calibrating?

      {
        y: item[:league_point] + item[:lp_variation].to_i,
        x: I18n.localize(item[:played_at], format: :short),
        label: format_label(item[:league_point], item[:lp_variation])
      }
    end
  end

  def format_label(value, variation)
    case
    when variation.nil? then ""
    when variation.positive? then " + #{variation.abs}"
    when variation.negative? then " - #{variation.abs}"
    else " + 0"
    end.then { "#{value}#{_1}" }
  end

  def chart_title
    RankedHistory.model_name.human
  end
end
