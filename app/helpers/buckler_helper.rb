module BucklerHelper
  def t_character(character)
    t("buckler.characters.#{character}")
  end

  def t_control_type(control_type, format: :long)
    t(control_type, scope: [ "buckler", "control_types", format ])
  end

  def t_battle_type(battle_type)
    t("buckler.battle_types.#{battle_type}")
  end

  def character_select_tag(name, **)
    options = Character.to_h { [ t_character(_1), _1.id ] }
    buckler_select_tag(name, options, **)
  end

  def control_type_select_tag(name, **)
    options = ControlType.to_h { [ t_control_type(_1), _1.id ] }
    buckler_select_tag(name, options, **)
  end

  def battle_type_select_tag(name, **)
    options = BattleType.to_h { [ t_battle_type(_1), _1.id ] }
    buckler_select_tag(name, options, **)
  end

  private

  def buckler_select_tag(name, options, selected: nil, include_any: false, **)
    options_tags = options_for_select(options, selected)
    options_tags = option_any.safe_concat(options_tags) if include_any
    select_tag(name, options_tags, **)
  end
end
