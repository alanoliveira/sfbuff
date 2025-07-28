module ScoresHelper
  def score_table_head
    safe_join [
      tag.th(t("attributes.score.total")),
      tag.th(t("attributes.score.wins")),
      tag.th(t("attributes.score.losses")),
      tag.th(t("attributes.score.draws")),
      tag.th(tag.span "Σ", title: t("attributes.score.diff")),
      tag.th(tag.span "%", title: t("attributes.score.ratio"))
    ]
  end

  def score_table_data(score)
    score.nil? ? score_table_data_none : score_table_data_some(score)
  end

  def score_ratio(win_percent)
    bs_class = case win_percent
    when ..40 then "text-danger"
    when 60.. then "text-success"
    else ""
    end
    content_tag :span, win_percent.round(2), class: bs_class
  end

  def score_diff(diff)
    bs_class = case diff
    when ..-1 then "text-danger"
    when 1.. then "text-success"
    else ""
    end
    tag.span format("%+d", diff), class: bs_class
  end

  private

  def score_table_data_some(score)
    safe_join [
      tag.td(score.total),
      tag.td(score.wins),
      tag.td(score.losses),
      tag.td(score.draws),
      tag.td(score_diff score.diff),
      tag.td(score_ratio score.ratio)
    ]
  end

  def score_table_data_none
    safe_join 6.times.map { tag.td("-") }
  end
end
