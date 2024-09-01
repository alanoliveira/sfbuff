class Battle < ApplicationRecord
  has_many :challengers, dependent: :destroy

  def p1
    challengers.find(&:p1?)
  end

  def p2
    challengers.find(&:p2?)
  end
end
