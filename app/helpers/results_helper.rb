module ResultsHelper
  def result_name(result)
    result.to_s
  end

  def result_badge(result)
    badge_class = case
    when result.win? then "bg-success"
    when result.lose? then "bg-danger"
    else "bg-warning"
    end

    title = result_name(result)
    tag.span title:, class: "badge p-2 rounded-circle #{badge_class}" do
      tag.span title, class: "visually-hidden"
    end
  end
end
