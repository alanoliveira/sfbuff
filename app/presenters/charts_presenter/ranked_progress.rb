module ChartsPresenter
  class RankedProgress
    def initialize(ranked_history)
      @ranked_history = ranked_history.to_a
    end

    def render_in(context)
      context.content_tag :canvas, nil, data: {
        controller: "chartjs",
        chartjs_type_value: "line",
        chartjs_options_value: options,
        chartjs_data_value: { datasets: }
      }
    end

    private

    def options
      {
        layout: { padding: { left: 30 } },
        plugins: {
          legend: { display: false },
          tooltip: { displayColors: false },
          marks: {
            "lp" => Buckler::LEAGUE_THRESHOLD.to_h { |points, name| [ points, { title: name.upcase } ] }
          },
          visit: {
            targets: @ranked_history.map { { url: Rails.application.routes.url_helpers.battle_path(_1.replay_id), options: { frame: "turbo-modal" } } }
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
        _1 << { data: lp_data, yAxisID: "lp", borderColor: CHART_COLORS[:red], backgroundColor: CHART_COLORS[:red] } if lp_data.any?
        _1 << { data: mr_data, yAxisID: "mr", borderColor: CHART_COLORS[:blue], backgroundColor: CHART_COLORS[:blue] } if mr_data.any?
      end
    end

    def mr_data
      @mr_data ||= @ranked_history.filter { _1.league_point.master? }.map do |item|
        {
          y: item.master_rating + item.master_rating_variation.to_i,
          x: I18n.localize(item.played_at, format: :short),
          label: format_label(item.master_rating, item.master_rating_variation)
        }
      end
    end

    def lp_data
      @lp_data ||= @ranked_history.reject { _1.league_point.master? }.map do |item|
        {
          y: item.league_point + item.league_point_variation.to_i,
          x: I18n.localize(item.played_at, format: :short),
          label: format_label(item.league_point, item.league_point_variation)
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
  end
end
