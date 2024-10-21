require 'rails_helper'

RSpec.describe EloCalculator do
  [
    { rating_a: 1000, rating_b: 1000, k: 16, win: 8, lose: -8, draw: 0 },
    { rating_a: 1882, rating_b: 1668, k: 16, win: 4, lose: -12, draw: -4 },
    { rating_a: 1642, rating_b: 1671, k: 16, win: 9, lose: -7, draw: 1 },
    { rating_a: 1595, rating_b: 1645, k: 16, win: 9, lose: -7, draw: 1 },
    { rating_a: 2043, rating_b: 2002, k: 16, win: 7, lose: -9, draw: -1 },
    { rating_a: 1651, rating_b: 1662, k: 16, win: 8, lose: -8, draw: 0 },
    { rating_a: 1839, rating_b: 1901, k: 16, win: 9, lose: -7, draw: 1 }
  ].each do |example|
    it do
        calculator = described_class.new(k: 16, **example.slice(:rating_a, :rating_b))
      expect(calculator.calculate(1)).to eq example[:win]
      expect(calculator.calculate(0)).to eq example[:lose]
      expect(calculator.calculate(0.5)).to eq example[:draw]
    end
  end
end
