module Match::MasterRatingCalculation
  extend ActiveSupport::Concern

  def mr_match?
    ranked? && home_mr.positive? && away_mr.positive?
  end

  def home_mr_variation
    MasterRatingCalculator.new(home_mr:, away_mr:, result:).calculate if mr_match?
  end
end
