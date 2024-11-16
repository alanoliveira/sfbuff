module ChartsHelper
  def ranked_history_chart(data, width: "100%", height: "100%")
    return if data.empty?

    lp_data, mr_data = data
      .map { RankedChartItemPresenter.from_ranked_history_item(_1) }
      .partition { _1[:kind] == "lp" }

    div_data = {
      controller: "ranked-history-chart",
      ranked_history_chart_lp_data_value: lp_data,
      ranked_history_chart_mr_data_value: mr_data,
      ranked_history_chart_lp_marks_value:
    }
    content_tag(:div, nil, style: "width: #{width}; height: #{height};", data: div_data) do
      content_tag :canvas, nil, data: { ranked_history_chart_target: "canvas" }
    end
  end

  def ranked_history_chart_lp_marks_value
    @ranked_history_chart_lp_marks_value ||=
      Buckler::Enums::LEAGUE_THRESHOLD.to_h { |points, name| [ points, { name: name.upcase } ] }
  end
end
