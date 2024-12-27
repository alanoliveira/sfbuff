class Battle < ApplicationRecord
  attribute :battle_type, :buckler_battle_type

  has_many :challengers, dependent: :destroy

  before_save :set_winner_side

  scope :ranked, -> { where(battle_type: BattleType["ranked"]) }
  scope :ordered, -> { order(:played_at) }

  def p1 = challengers.find(&:p1?)
  def p2 = challengers.find(&:p2?)

  def ranked?
    battle_type == BattleType["ranked"]
  end

  def master_battle?
    ranked? && p1.master? && p2.master?
  end

  def mr_variation(side)
    mr_calculator.try("#{side}_variation")
  end

  def to_param
    replay_id
  end

  def winner
    p1_w = p1.rounds.count(&:win?)
    p2_w = p2.rounds.count(&:win?)
    self.winner_side = case
    when p1_w > p2_w then p1
    when p2_w > p1_w then p2
    end
  end

  private

  def mr_calculator
    MrCalculator.new(self) if master_battle?
  end

  def set_winner_side
    self.winner_side = winner&.side_for_database
  end
end
