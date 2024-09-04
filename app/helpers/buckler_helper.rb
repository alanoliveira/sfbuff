module BucklerHelper
  def t_character(value)
    name = Buckler::Enums::CHARACTERS.key value.to_i
    return value if name.nil?

    t("buckler.character.#{name}")
  end

  def t_control_type(value, format: :long)
    name = Buckler::Enums::CONTROL_TYPES.key value.to_i
    return value if name.nil?

    scope = %w[buckler control_type]
    scope << "short" if format == :short
    t(name, scope:)
  end

  def t_battle_type(value)
    name = Buckler::Enums::BATTLE_TYPES.key value.to_i
    return value if name.nil?

    t("buckler.battle_type.#{name}")
  end

  def t_round(value)
    name = Buckler::Enums::ROUNDS.key value.to_i
    return value if name.nil?

    name
  end
end
