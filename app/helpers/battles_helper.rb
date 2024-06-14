# frozen_string_literal: true

module BattlesHelper
  def rival_score_span(diff)
    css_class = case diff
                when ..-1 then 'text-danger'
                when 1.. then 'text-success'
                else ''
                end
    content_tag(:span, format('%+d', diff), class: css_class)
  end

  def mr_variation_span(variation)
    css_class = case variation
                when ..-1 then 'text-danger'
                when 1.. then 'text-success'
                else ''
                end
    content_tag(:span, format('%+d', variation), class: css_class)
  end

  def round_result(round_id)
    round = Buckler::ROUNDS.key(round_id)
    content_tag :span, round, style: 'width: 20px', class: "badge px-0 text-center round-#{round}"
  end

  def character_select(form, attribute, include_any: false, **)
    choises = Buckler::CHARACTERS.values.index_by { character _1 }
    select_list(form, attribute, choises, include_any:, **)
  end

  def control_type_select(form, attribute, include_any: false, **)
    choises = Buckler::CONTROL_TYPES.values.index_by { control_type(_1, format: :long) }
    select_list(form, attribute, choises, include_any:, **)
  end

  def battle_type_select(form, attribute, include_any: false, **)
    choises = Buckler::BATTLE_TYPES.values.index_by { battle_type _1 }
    select_list(form, attribute, choises, include_any:, **)
  end
end
