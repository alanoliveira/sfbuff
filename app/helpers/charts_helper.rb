module ChartsHelper
  def ranked_history_chart(ranked_history, **opts)
    ranked_history.filter_map do |history_item|
      data = {
        x: l(history_item.played_at, format: :short),
        link: battle_path(history_item.replay_id)
      }

      if history_item.master_rating_variation.present?
        data[:type] = "mr"
        data[:label] = format("%d (%+d)", history_item.master_rating, history_item.master_rating_variation)
        data[:y] = history_item.master_rating + history_item.master_rating_variation
      else
        data[:type] = "lp"
        data[:y] = history_item.league_point
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

  def matchups_group_by_date_chart(matchups, width: "100%", height: "100%")
    data = matchups.map { MatchupsGroupByDateChartItemPresenter.from_result_query(_1) }

    content_tag :div, data: { controller: "matchups-group-by-date-chart", matchups_group_by_date_chart_data_value: data } do
      content_tag :canvas, nil, data: { matchups_group_by_date_chart_target: "canvas" }
    end
  end
end
