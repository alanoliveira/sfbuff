module Battle::HasChallengers
  extend ActiveSupport::Concern

  SIDES = %i[ p1 p2 ]
  MAPPED_ATTRIBUTES = %i[ fighter_id character_id playing_character_id
    input_type_id mr lp name round_ids ]

  included do
    before_save :set_winner_side

    SIDES.each do |p_side|
      composed_of p_side, class_name: "Battle::Challenger",
        mapping: MAPPED_ATTRIBUTES.to_h { [ "#{p_side}_#{it}", it ] }
    end
  end

  def challengers
    SIDES.map { send(it) }
  end

  private

  def set_winner_side
    self.winner_side = eval_winner_side
  end

  def eval_winner_side
    p1_wins = p1.rounds.count(&:win?)
    p2_wins = p2.rounds.count(&:win?)

    if p1_wins > p2_wins then 1
    elsif p2_wins > p1_wins then 2
    else 0
    end
  end
end
