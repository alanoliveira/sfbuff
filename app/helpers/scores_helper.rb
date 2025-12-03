module ScoresHelper
  def score_ratio_tag(ratio)
    return unless ratio.present?

    bs_class = case ratio
    when ..40 then "text-danger"
    when 60.. then "text-success"
    else ""
    end
    content_tag :span, ratio.round(2), class: bs_class
  end

  def score_diff_tag(diff)
    return unless diff.present?

    bs_class = case diff
    when ..-1 then "text-danger"
    when 1.. then "text-success"
    else ""
    end
    content_tag :span, format("%+d", diff), class: bs_class
  end
end
