class Battle < ApplicationRecord
  has_many :challengers, dependent: :destroy do
    def p1 = find(&:p1?)
    def p2 = find(&:p2?)
    def winner = find { _1.side == proxy_association.owner.winner_side }
  end

  attribute :winner_side, Challenger.type_for_attribute(:side)

  before_save :set_winner_side

  scope :ranked, -> { where(battle_type: Buckler::Enums::BATTLE_TYPES["ranked"]) }
  scope :ordered, -> { order(:played_at) }

  def ranked?
    battle_type == Buckler::Enums::BATTLE_TYPES["ranked"]
  end

  def master_battle?
    ranked? && challengers.all?(&:master?)
  end

  def mr_calculator
    MrCalculator if master_battle?
  end

  def to_param
    replay_id
  end

  private

  def set_winner_side
    return unless has_attribute?("winner_side")
    p1_w = challengers.p1.rounds.count(&:win?)
    p2_w = challengers.p2.rounds.count(&:win?)
    self.winner_side = case
    when p1_w > p2_w then challengers.p1.side
    when p2_w > p1_w then challengers.p2.side
    end
  end
end
