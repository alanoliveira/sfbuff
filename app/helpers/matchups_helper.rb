module MatchupsHelper
  def result_badge(result)
    badge_class = case result
    when "win" then "bg-success"
    when "lose" then "bg-danger"
    when "draw" then "bg-warning"
    end

    title = t("attributes.results.#{result}")
    tag.span title:, class: "badge p-2 rounded-circle #{badge_class}" do
      tag.span title, class: "visually-hidden"
    end
  end
end
