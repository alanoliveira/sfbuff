module MatchupsHelper
  def link_to_matchup_score_by_date_chart(matchup, **)
    link_to_modal icon("bar-chart-fill"), matchups_score_by_date_chart_path(matchup), aria: { label: t("buttons.chart") }, **
  end

  def result_badge(matchup)
    badge_class = case
    when matchup.win? then "bg-success"
    when matchup.loss? then "bg-danger"
    else "bg-warning"
    end

    title = Matchup.human_attribute_name("result/#{matchup.result}")
    tag.span title:, class: "badge p-2 rounded-circle #{badge_class}" do
      tag.span title, class: "visually-hidden"
    end
  end
end
