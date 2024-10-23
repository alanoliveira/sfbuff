require 'rails_helper'

RSpec.describe EloCalculator do
  [
    { rating_a: 1000, rating_b: 1000, k: 10, ratio: 1.0, res: 5.0 },
    { rating_a: 1000, rating_b: 1000, k: 10, ratio: 0, res: -5.0 },
    { rating_a: 1200, rating_b: 1000, k: 10, ratio: 0.8, res: 0.4025 },
    { rating_a: 900, rating_b: 1000, k: 10, ratio: 0, res: -3.5993 }
  ].each do |example|
    it do
      calculator = described_class.new(**example.slice(:k, :rating_a, :rating_b))
      expect(calculator.calculate(example[:ratio])).to be_within(0.001).of(example[:res])
    end
  end
end
