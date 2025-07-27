module EnumsHelper
  def options_for_character_select
    Enums::CHARACTERS.keys.to_h { [ character_name(it), it ] }
  end

  def options_for_input_type_select
    Enums::INPUT_TYPES.keys.to_h { [ input_type_name(it), it ] }
  end

  def options_for_battle_type_select
    Enums::BATTLE_TYPES.keys.to_h { [ battle_type_name(it), it ] }
  end

  def character_name(id)
    I18n.t(Enums::CHARACTERS[id], scope: "enums.characters", default: "Character##{id}")
  end

  def input_type_name(id, scope = "short")
    I18n.t(Enums::INPUT_TYPES[id], scope: "enums.input_types.#{scope}")
  end

  def battle_type_name(id)
    I18n.t(Enums::BATTLE_TYPES[id], scope: "enums.battle_types")
  end
end
