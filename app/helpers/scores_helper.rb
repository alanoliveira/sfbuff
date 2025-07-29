module ScoresHelper
  def score_table_head
    safe_join [
      tag.th(Matchup::Score.human_attribute_name :total),
      tag.th(Matchup::Score.human_attribute_name :wins),
      tag.th(Matchup::Score.human_attribute_name :losses),
      tag.th(Matchup::Score.human_attribute_name :draws),
      tag.th(tag.span "Σ", title: Matchup::Score.human_attribute_name(:diff)),
      tag.th(tag.span "%", title: Matchup::Score.human_attribute_name(:ratio))
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
