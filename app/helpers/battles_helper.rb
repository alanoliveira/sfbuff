# frozen_string_literal: true

module BattlesHelper
  def n_battles_found_alert(count)
    kind = count.zero? ? 'warning' : 'info'
    alert t('helpers.battles_found', count:), dismissible: true, kind:
  end

  def round_result_span(round_id)
    rr = round_result(round_id)
    content_tag :span, rr.upcase, style: 'width: 20px', class: "badge px-0 text-center round-#{rr}"
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
