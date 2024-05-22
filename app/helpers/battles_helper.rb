# frozen_string_literal: true

module BattlesHelper
  RIVALS_ROWS = 5

  def favorites(battles)
    battles.rivals(order: 'total DESC', limit: RIVALS_ROWS)
  end

  def victims(battles)
    battles.rivals(order: 'diff DESC', limit: RIVALS_ROWS)
  end

  def tormentors(battles)
    battles.rivals(order: 'diff ASC', limit: RIVALS_ROWS)
  end

  def battle_type_span(battle_type_id)
    content_tag :span, Buckler::BATTLE_TYPES[battle_type_id]
  end

  def character_name(character_id)
    content_tag :span, Buckler::CHARACTERS[character_id]
  end

  def control_type(control_type_id)
    control_type = Buckler::CONTROL_TYPES[control_type_id]
    content_tag :span, control_type[0].upcase
  end

  def rival_score_span(diff)
    css_class = case diff
                when ..-1 then 'text-danger'
                when 1.. then 'text-success'
                else ''
                end
    content_tag(:span, format('%+d', diff), class: css_class)
  end

  def round_result(round_id)
    round = Buckler::ROUNDS[round_id]
    content_tag :span, round, style: 'width: 20px', class: "badge px-0 text-center round-#{round.downcase}"
  end
end
