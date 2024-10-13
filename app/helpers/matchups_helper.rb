module MatchupsHelper
  def battle_result(result)
    css_class = case result
    when "win" then "text-success"
    when "draw" then "text-secondary"
    else "text-danger"
    end
    content_tag :span, Challenger.human_attribute_name("result.#{result}").upcase, class: css_class
  end

  def score_bar(score, **)
    bs_progress_bar_stacked(progresses: [
      { percent: score.win_percent, bg_class: "bg-success", aria: { value_now: score.win_percent } },
      { percent: score.draw_percent, bg_class: "bg-warning", aria: { value_now: score.draw_percent } },
      { percent: score.lose_percent, bg_class: "bg-danger", aria: { value_now: score.lose_percent } }
    ], **)
  end
end
