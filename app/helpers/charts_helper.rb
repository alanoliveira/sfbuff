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

  def format_league_point_data(challenger)
    {
      points: challenger.league_point,
      tooltip: challenger.league_point,
      title: I18n.l(challenger.battle.played_at, format: :short),
      played_at: challenger.battle.played_at,
      battle_url: battle_path(challenger.battle.replay_id)
    }
  end

  def format_master_rating_data(challenger)
    tooltip = format('%<points>d %<variation>+d', points: challenger.master_rating,
                                                  variation: challenger.mr_variation)
    {
      points: challenger.master_rating + challenger.mr_variation,
      tooltip:,
      title: I18n.l(challenger.battle.played_at, format: :short),
      played_at: challenger.battle.played_at,
      battle_url: battle_path(challenger.battle.replay_id)
    }
  end
end
