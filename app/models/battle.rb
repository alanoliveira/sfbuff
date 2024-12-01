class Battle < ApplicationRecord
  with_options class_name: "Challenger", dependent: :destroy do
    has_one :p1, -> { where(side: "p1") }
    has_one :p2, -> { where(side: "p2") }
  end

  attribute :battle_type, :buckler_battle_type
  attribute :winner_side, Challenger.type_for_attribute(:side)

  before_save :set_winner_side

  scope :by_matchup, Matchup
  scope :ranked, -> { where(battle_type: BattleType["ranked"]) }
  scope :ordered, -> { order(:played_at) }

  def ranked?
    battle_type == BattleType["ranked"]
  end

  def challengers
    [ p1, p2 ]
  end

  def master_battle?
    ranked? && p1.master? && p2.master?
  end

  def mr_calculator
    MrCalculator.new(self) if master_battle?
  end

  def to_param
    replay_id
  end

  private

  def set_winner_side
    p1_w = p1.rounds.count(&:win?)
    p2_w = p2.rounds.count(&:win?)
    self.winner_side = case
    when p1_w > p2_w then p1.side
    when p2_w > p1_w then p2.side
    end
  end
end
