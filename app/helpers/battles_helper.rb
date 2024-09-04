module BattlesHelper
  def battle_footer_result(winner_short_id:, pov_short_id:)
    text, css_class = case winner_short_id
    when pov_short_id then [ "win", "text-success" ]
    when nil then [ "draw", "text-secondary" ]
    else [ "lose", "text-danger" ]
    end
    content_tag :span, t(text, scope: "common", count: 1).upcase, class: css_class
  end
end
