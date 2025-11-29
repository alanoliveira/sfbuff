require 'rails_helper'

RSpec.describe Score do
  describe "#+" do
    it do
      score1 = described_class.new(wins: 3, losses: 2, draws: 1)
      score2 = described_class.new(wins: 8, losses: 3, draws: 0)
      expect(score1 + score2).to eq(described_class.new(wins: 11, losses: 5, draws: 1))
    end
  end
end
