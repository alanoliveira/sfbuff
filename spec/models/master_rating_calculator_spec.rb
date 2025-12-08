require "rails_helper"

RSpec.describe MasterRatingCalculator do
  [
    { home_mr: 1000, away_mr: 1000, win: 8, loss: -8, draw: 0 },
    { home_mr: 1882, away_mr: 1668, win: 4, loss: -12, draw: -4 },
    { home_mr: 1642, away_mr: 1671, win: 9, loss: -7, draw: 1 },
    { home_mr: 1595, away_mr: 1645, win: 9, loss: -7, draw: 1 },
    { home_mr: 2043, away_mr: 2002, win: 7, loss: -9, draw: -1 },
    { home_mr: 1651, away_mr: 1662, win: 8, loss: -8, draw: 0 },
    { home_mr: 1839, away_mr: 1901, win: 9, loss: -7, draw: 1 }
  ].each do |example|
    it { expect(described_class.new(home_mr: example[:home_mr], away_mr: example[:away_mr], result: Result::WIN).calculate).to eq example[:win] }
    it { expect(described_class.new(home_mr: example[:home_mr], away_mr: example[:away_mr], result: Result::LOSS).calculate).to eq example[:loss] }
    it { expect(described_class.new(home_mr: example[:home_mr], away_mr: example[:away_mr], result: Result::DRAW).calculate).to eq example[:draw] }
  end
end
