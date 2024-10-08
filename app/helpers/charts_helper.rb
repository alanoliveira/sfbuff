module ChartsHelper
  def history_chart(matchups, **opts)
    matchups.filter_map do |mu|
      data = {
        x: l(mu.battle.played_at, format: :short),
        link: battle_path(mu.battle.replay_id)
      }

      if mu.home_challenger.master?
        next if mu.home_challenger.master_rating.zero? || !mu.away_challenger.master?

        data[:type] = "mr"
        data[:label] = format("%d (%+d)", mu.home_challenger.master_rating, mu.home_challenger.mr_variation)
        data[:y] = mu.home_challenger.master_rating + mu.home_challenger.mr_variation
      else
        next if mu.home_challenger.calibrating?
        data[:type] = "lp"
        data[:y] = mu.home_challenger.league_point
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
      Challenger::LEAGUE_THRESHOLD.to_h { |points, name| [ points, { name: name.upcase } ] }
  end
end
