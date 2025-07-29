require 'rails_helper'

RSpec.describe Matchup::Score do
  describe "#total" do
    it "returns win + lose + draw" do
      expect(described_class.new(wins: 4, losses: 2, draws: 3).total).to eq 9
    end
  end

  describe "#diff" do
    context "when wins > losses" do
      it "returns a positive number representing wins - losses" do
        expect(described_class.new(wins: 4, losses: 2, draws: 3).diff).to eq 2
      end
    end

    context "when losses > wins" do
      it "returns a negative number representing wins - losses" do
        expect(described_class.new(wins: 2, losses: 4, draws: 3).diff).to eq -2
      end
    end
  end

  describe "#ratio" do
    it "returns wins percentage" do
      expect(described_class.new(wins: 7, losses: 3, draws: 3).ratio).to be_within(0.1).of(65.38)
    end
  end

  describe "#+" do
    it "returns a new described_class with the sum of the values" do
      score_a = described_class.new(wins: 8, losses: 3, draws: 1)
      score_b = described_class.new(wins: 1, losses: 5, draws: 4)
      expect(score_a + score_b).to eq described_class.new(wins: 9, losses: 8, draws: 5)
    end
  end
end
