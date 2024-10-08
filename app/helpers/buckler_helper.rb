module BucklerHelper
  def t_character(value)
    name = Buckler::Enums::CHARACTERS.key value.to_i
    return value if name.nil?

    t("buckler.characters.#{name}")
  end

  def t_control_type(value, format: :long)
    name = Buckler::Enums::CONTROL_TYPES.key value.to_i
    return value if name.nil?

    t(name, scope: [ "buckler", "control_types", format ])
  end

  def t_battle_type(value)
    name = Buckler::Enums::BATTLE_TYPES.key value.to_i
    return value if name.nil?

    t("buckler.battle_types.#{name}")
  end

  def t_round(value)
    name = Buckler::Enums::ROUNDS.key value.to_i
    return value if name.nil?

    name
  end

  def character_select_tag(name, **)
    options = Buckler::Enums::CHARACTERS.values.index_by { t_character _1 }
    buckler_select_tag(name, options, **)
  end

  def control_type_select_tag(name, **)
    options = Buckler::Enums::CONTROL_TYPES.values.index_by { t_control_type _1 }
    buckler_select_tag(name, options, **)
  end

  def battle_type_select_tag(name, **)
    options = Buckler::Enums::BATTLE_TYPES.values.index_by { t_battle_type _1 }
    buckler_select_tag(name, options, **)
  end

  private

  def buckler_select_tag(name, options, selected: nil, include_any: false, **)
    options_tags = options_for_select(options, selected)
    options_tags = option_any.safe_concat(options_tags) if include_any
    select_tag(name, options_tags, **)
  end
end
