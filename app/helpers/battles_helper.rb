module BattlesHelper
  def link_to_battle(replay_id)
    link_to_modal replay_id, battle_path(replay_id)
  end
end
