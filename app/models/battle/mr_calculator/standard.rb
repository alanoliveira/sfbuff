class Battle::MrCalculator::Standard
  ELO_CONSTANT = 16

  def initialize(mr_a, mr_b)
    @elo_calculator = EloCalculator.new(rating_a: mr_a, rating_b: mr_b, k: ELO_CONSTANT)
  end

  def win
    calculate(1)
  end

  def lose
    calculate(0)
  end

  def draw
    calculate(0.5)
  end

  private

  def calculate(ratio)
    @elo_calculator.calculate(ratio).round
  end
end
