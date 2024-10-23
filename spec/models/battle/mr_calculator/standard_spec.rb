require 'rails_helper'

RSpec.describe Battle::MrCalculator::Standard do
  [
    { mr_a: 1000, mr_b: 1000, win: 8, lose: -8, draw: 0 },
    { mr_a: 1882, mr_b: 1668, win: 4, lose: -12, draw: -4 },
    { mr_a: 1642, mr_b: 1671, win: 9, lose: -7, draw: 1 },
    { mr_a: 1595, mr_b: 1645, win: 9, lose: -7, draw: 1 },
    { mr_a: 2043, mr_b: 2002, win: 7, lose: -9, draw: -1 },
    { mr_a: 1651, mr_b: 1662, win: 8, lose: -8, draw: 0 },
    { mr_a: 1839, mr_b: 1901, win: 9, lose: -7, draw: 1 }
  ].each do |example|
    it do
      calculator = described_class.new(*example.values_at(:mr_a, :mr_b))
      expect(calculator.win).to eq example[:win]
      expect(calculator.lose).to eq example[:lose]
      expect(calculator.draw).to eq example[:draw]
    end
  end
end
