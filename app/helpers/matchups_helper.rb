module MatchupsHelper
  def result_badge(result)
    badge_class = case result
    when "win" then "text-bg-success"
    when "lose" then "text-bg-danger"
    when "draw" then "text-bg-warning"
    end

    tag.span t("attributes.result.#{result}"), class: "badge #{badge_class}"
  end
end
