module ChartsHelper
  RANK_MARKS = {
    1000 => { name: "IRON" },
    3000 => { name: "BRONZE" },
    5000 => { name: "SILVER" },
    9000 => { name: "GOLD" },
    13000 => { name: "PLATINUM" },
    19000 => { name: "DIAMOND" },
    25000 => { name: "MASTER" }
  }.freeze

  def history_chart(ranked_history, **opts)
    master = false
    ranked_history.reject do |it|
      master ||= it.master_rating.positive?
      it.calibration? || (master && !it.mr_variated?)
    end.map do |it|
      data = {
        x: l(it.played_at, format: :short),
        link: battle_path(it.replay_id)
      }

      if it.mr_variated?
        data[:type] = "mr"
        data[:label] = format("%<master_rating>d (%<mr_variation>+d)", it.to_h)
        data[:y] = it.master_rating + it.mr_variation
      else
        data[:type] = "lp"
        data[:y] = it.league_point
      end

      data
    end.then { draw_chart(_1, **opts) }
  end

  private

  def draw_chart(data, width: "100%", height: "100%")
    return if data.empty?

    lp_data, mr_data = data.partition { _1[:type] == "lp" }

    div_data = {
      controller: "ranked-history-chart",
      ranked_history_chart_lp_data_value: lp_data,
      ranked_history_chart_mr_data_value: mr_data,
      ranked_history_chart_lp_marks_value: RANK_MARKS
    }
    content_tag(:div, nil, style: "width: #{width}; height: #{height};", data: div_data) do
      content_tag :canvas, nil, data: { ranked_history_chart_target: "canvas" }
    end
  end
end
