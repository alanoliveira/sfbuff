module ResultsHelper
  def result_badge(result)
    badge_class = case result
    when Result::WIN then "bg-success"
    when Result::LOSS then "bg-danger"
    else "bg-warning"
    end

    title = result.name
    tag.span title:, class: "badge p-2 rounded-circle #{badge_class}" do
      tag.span title, class: "visually-hidden"
    end
  end
end
