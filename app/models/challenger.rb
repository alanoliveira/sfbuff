class Challenger < ApplicationRecord
  enum :result, %w[draw win lose]
  enum :side, { "p1" => 1, "p2" => 2 }
  decorate_attributes([ :rounds ]) { |_, subtype| RoundsType.new(subtype) }

  belongs_to :battle

  before_save :set_result

  scope :join_vs, JoinVs

  def master?
    master_rating.positive?
  end

  def vs
    battle.challengers.find { |c| side != c.side }
  end

  def mr_variation
    calculator_class = battle.mr_calculator
    return if calculator_class.nil?

    calculator = calculator_class.new(my_mr: master_rating, vs_mr: vs.master_rating)
    return calculator.win_variation if win?
    return calculator.lose_variation if lose?
    calculator.draw_variation
  end

  private

  def set_result
    self.result = case rounds.count(&:win?) - rounds.count(&:lose?)
    when (..-1) then "lose"
    when (1..) then "win"
    when 0 then "draw"
    end
  end
end
