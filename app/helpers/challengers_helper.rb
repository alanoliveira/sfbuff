module ChallengersHelper
  def challenger_result(challenger)
    css_class = case challenger.result
    when "win" then "text-success"
    when "draw" then "text-secondary"
    else "text-danger"
    end
    content_tag :span, Challenger.human_attribute_name("result.#{challenger.result}").upcase, class: css_class
  end
end
