class EloCalculator
  attr_reader :rating_a, :rating_b, :k

  def initialize(rating_a:, rating_b:, k:)
    @rating_a = rating_a
    @rating_b = rating_b
    @k = k
  end

  def calculate(actual)
    (k * (actual - expected)).round
  end

  private

  def expected
    1 / (1 + (10 ** (diff / 400.0)))
  end

  def diff
    rating_b - rating_a
  end
end
