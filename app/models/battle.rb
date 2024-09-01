class Battle < ApplicationRecord
  has_many :challengers, dependent: :destroy

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
    challengers.find { |c| c.win? }
  end

  def mr_calculator
    MrCalculator if ranked? && challengers.all?(&:master?)
  end
end
