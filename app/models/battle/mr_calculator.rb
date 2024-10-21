class Battle::MrCalculator
  ELO_CONSTANT = 16

  attr_reader :my_mr, :vs_mr

  def initialize(my_mr:, vs_mr:)
    @my_mr = my_mr
    @vs_mr = vs_mr
  end

  def win_variation
    calculator.calculate(1)
  end

  def lose_variation
    calculator.calculate(0)
  end

  def draw_variation
    calculator.calculate(0.5)
  end

  private

  def calculator
    EloCalculator.new(rating_a: my_mr, rating_b: vs_mr, k: ELO_CONSTANT)
  end
end
