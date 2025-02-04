module MatchupsHelper
  def link_to_matchup_score_by_date_chart(matchup, **)
    link_to_modal icon("bar-chart-fill"), matchups_score_by_date_chart_path(matchup), **
  end
end
