module BattlesHelper
  def link_to_battle(replay_id)
    link_to_modal replay_id, battle_path(replay_id)
  end

  def battle_type_name(battle_type)
    Battle.human_attribute_name "battle_types/#{battle_type}"
  end

  def battle_types_options_for_select
    Battle.battle_types.to_h { |key, val| [ battle_type_name(key), val ] }
  end
end
