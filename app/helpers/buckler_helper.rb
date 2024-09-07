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

  def options_for_character_select
    Buckler::Enums::CHARACTERS.values.index_by { t_character _1 }
  end

  def options_for_control_type_select
    Buckler::Enums::CONTROL_TYPES.values.index_by { t_control_type _1 }
  end

  def options_for_battle_type_select
    Buckler::Enums::BATTLE_TYPES.values.index_by { t_battle_type _1 }
  end
end
