class Battle::MrCalculator
  attr_reader :battle

  def initialize(battle, calculator_class: Standard)
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
    @variations = case battle.winner&.side
    when "p1" then [ p1_calculator.win, p2_calculator.lose ]
    when "p2" then [ p1_calculator.lose, p2_calculator.win ]
    else [ p1_calculator.draw, p2_calculator.draw ]
    end
  end

  def p1_calculator
    @calculator_class.new(p1_master_rating, p2_master_rating)
  end

  def p2_calculator
    @calculator_class.new(p2_master_rating, p1_master_rating)
  end

  def p1_master_rating
    battle.p1.actual_master_rating
  end

  def p2_master_rating
    battle.p2.actual_master_rating
  end
end
