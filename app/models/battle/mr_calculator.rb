class Battle::MrCalculator
  attr_reader :battle

  def initialize(battle, calculator_class: StandardCalculator)
    @battle = battle
    @calculator_class = calculator_class
  end

  def p1_variation
    variations.first
  end

  def p2_variation
    variations.last
  end

  private

  def variations
    @variations = case battle.winner_side
    when "p1" then [ p1_calculator.win, p2_calculator.lose ]
    when "p2" then [ p1_calculator.lose, p2_calculator.win ]
    else [ p1_calculator.draw, p2_calculator.draw ]
    end
  end

  def p1_calculator
    @calculator_class.new(battle.p1.master_rating, battle.p2.master_rating)
  end

  def p2_calculator
    @calculator_class.new(battle.p2.master_rating, battle.p1.master_rating)
  end

  class StandardCalculator
    ELO_CONSTANT = 16

    def initialize(mr_a, mr_b)
      @elo_calculator = EloCalculator.new(rating_a: mr_a, rating_b: mr_b, k: ELO_CONSTANT)
    end

    def win
      @elo_calculator.calculate(1)
    end

    def lose
      @elo_calculator.calculate(0)
    end

    def draw
      @elo_calculator.calculate(0.5)
    end
  end
end
