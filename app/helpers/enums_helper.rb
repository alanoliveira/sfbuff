module EnumsHelper
  def options_for_character_select(...)
    options_for_enum_select(Enums::CHARACTERS.keys.to_h { [ character_name(it), it ] }, ...)
  end

  def options_for_input_type_select(...)
    options_for_enum_select(Enums::INPUT_TYPES.keys.to_h { [ input_type_name(it), it ] }, ...)
  end

  def options_for_battle_type_select(...)
    options_for_enum_select(Enums::BATTLE_TYPES.keys.to_h { [ battle_type_name(it), it ] }, ...)
  end

  def character_name(id)
    I18n.t(Enums::CHARACTERS[id.to_i], scope: "enums.characters", default: "Character##{id}")
  end

  def input_type_name(id, scope = "short")
    I18n.t(Enums::INPUT_TYPES[id.to_i], scope: "enums.input_types.#{scope}")
  end

  def battle_type_name(id)
    I18n.t(Enums::BATTLE_TYPES[id.to_i], scope: "enums.battle_types")
  end

  def country_name(id)
    I18n.t(Enums::COUNTRIES[id.to_i], scope: "enums.countries")
  end

  def options_for_enum_select(hash, selected = nil, include_any: true)
    any_option = tag.option(t("common.any"), value: "") if include_any
    safe_join [ any_option, options_for_select(hash, selected) ]
  end
end
