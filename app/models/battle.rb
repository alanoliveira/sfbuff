class Battle < ApplicationRecord
  has_many :challengers, dependent: :destroy do
    def by_short_id(short_id)
      find { _1.short_id == short_id }
    end
  end

  scope :ranked, -> { where(battle_type: Buckler::Enums::BATTLE_TYPES["ranked"]) }
  scope :ordered, -> { order(:played_at) }
  scope :with_scores, -> { joins(:challengers).extending(ResultScorable) }

  def ranked?
    battle_type == Buckler::Enums::BATTLE_TYPES["ranked"]
  end

  def p1
    challengers.find(&:p1?)
  end

  def p2
    challengers.find(&:p2?)
  end

  def winner
    challengers.find(&:win?)
  end

  def mr_calculator
    MrCalculator if ranked? && challengers.all?(&:master?)
  end

  def to_param
    replay_id
  end
end
