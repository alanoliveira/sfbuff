Battle::Challenger = Struct.new(
  :fighter_id,
  :character_id,
  :playing_character_id,
  :input_type_id,
  :mr,
  :lp,
  :name,
  :round_ids,
)

class Battle::Challenger
  def rounds
    round_ids.map { Battle::Round[it] }.freeze
  end
end
