module MatchupsHelper
  def battle_result(result)
    css_class = case result
    when "win" then "text-success"
    when "draw" then "text-secondary"
    else "text-danger"
    end
    content_tag :span, Challenger.human_attribute_name("result.#{result}").upcase, class: css_class
  end
end
