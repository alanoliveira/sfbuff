# frozen_string_literal: true

module ChartsHelper
  def league_point_chart(data, **)
    battle_points_chart(data.map { format_league_point_data _1 }, **)
  end

  def master_rating_chart(data, **)
    battle_points_chart(data.map { format_master_rating_data _1 }, **)
  end

  private

  def battle_points_chart(data, frame:, width: '100%', height: '100%')
    div_data = {
      controller: 'battle-points-chart',
      battle_points_chart_frame_value: frame,
      battle_points_chart_data_value: data.to_json
    }
    content_tag(:div, style: "position: relative; width: #{width}; height: #{height};", data: div_data) do
      content_tag :canvas, '', data: { battle_points_chart_target: 'canvas' }
    end
  end

  def format_league_point_data(history_item)
    {
      points: history_item.points,
      tooltip: history_item.points,
      title: I18n.l(history_item.played_at, format: :short),
      played_at: history_item.played_at,
      battle_url: battle_path(history_item.replay_id)
    }
  end

  def format_master_rating_data(history_item)
    tooltip = format('%<points>d %<variation>+d', points: history_item.points,
                                                  variation: history_item.variation)
    {
      points: history_item.points + history_item.variation,
      tooltip:,
      title: I18n.l(history_item.played_at, format: :short),
      played_at: history_item.played_at,
      battle_url: battle_path(history_item.replay_id)
    }
  end
end
