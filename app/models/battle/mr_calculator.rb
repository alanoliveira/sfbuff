class Battle::MrCalculator
  attr_reader :my_mr, :vs_mr

  def initialize(my_mr:, vs_mr:)
    @my_mr = my_mr
    @vs_mr = vs_mr
  end

  def win_variation
    calculate(1)
  end

  def lose_variation
    calculate(0)
  end

  def draw_variation
    calculate(0.5)
  end

  private

  def calculate(minuend)
    (16 * (minuend - base)).round
  end

  def base
    @base ||= 1 / (1 + (10**((vs_mr - my_mr) / 400.0)))
  end
end
