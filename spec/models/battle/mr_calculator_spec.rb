require 'rails_helper'

RSpec.describe Battle::MrCalculator do
  [
    { my_mr: 1000, vs_mr: 1000, win: 8, lose: -8, draw: 0 },
    { my_mr: 1882, vs_mr: 1668, win: 4, lose: -12, draw: -4 },
    { my_mr: 1642, vs_mr: 1671, win: 9, lose: -7, draw: 1 },
    { my_mr: 1595, vs_mr: 1645, win: 9, lose: -7, draw: 1 },
    { my_mr: 2043, vs_mr: 2002, win: 7, lose: -9, draw: -1 },
    { my_mr: 1651, vs_mr: 1662, win: 8, lose: -8, draw: 0 },
    { my_mr: 1839, vs_mr: 1901, win: 9, lose: -7, draw: 1 }
  ].each do |example|
    it do
      calculator = described_class.new(my_mr: example[:my_mr], vs_mr: example[:vs_mr])
      expect(calculator.win_variation).to eq example[:win]
      expect(calculator.lose_variation).to eq example[:lose]
      expect(calculator.draw_variation).to eq example[:draw]
    end
  end
end
