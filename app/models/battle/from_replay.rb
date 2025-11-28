module Battle::FromReplay
  extend ActiveSupport::Concern

  def from_replay(replay)
    self[:replay_id] = replay.replay_id
    self[:battle_type_id] = replay.replay_battle_type
    self[:played_at] = replay.uploaded_at

    [ 1, 2 ].each do |side|
      player_info = replay.public_send("player#{side}_info")
      self[:"p#{side}_fighter_id"] = player_info.short_id
      self[:"p#{side}_name"] = player_info.fighter_id
      self[:"p#{side}_character_id"] = player_info.character_id
      self[:"p#{side}_playing_character_id"] = player_info.playing_character_id
      self[:"p#{side}_input_type_id"] = player_info.battle_input_type
      self[:"p#{side}_mr"] = player_info.master_rating
      self[:"p#{side}_lp"] = player_info.league_point
      self[:"p#{side}_rounds"] = player_info.round_results
    end

    self
  end
end
