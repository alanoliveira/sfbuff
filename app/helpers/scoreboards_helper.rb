module ScoreboardsHelper
  def score_win_percent(win_percent)
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
end
