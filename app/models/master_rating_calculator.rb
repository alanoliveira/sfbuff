class MasterRatingCalculator
  attr_reader :home_mr, :away_mr, :result

  def initialize(home_mr:, away_mr:, result:)
    @home_mr = home_mr
    @away_mr = away_mr
    @result = result
  end

  def calculate
    (16 * (weight - base)).round
  end

  private

  def weight
    case result
    when Result::WIN then 1
    when Result::LOSS then 0
    when Result::DRAW then 0.5
    end
  end

  def base
    1 / (1+(10 ** ((away_mr - home_mr) / 400.0)))
  end
end
