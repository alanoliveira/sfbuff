class Battle < ApplicationRecord
  has_many :challengers, dependent: :destroy do
    def p1 = find(&:p1?)
    def p2 = find(&:p2?)
  end

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
end
