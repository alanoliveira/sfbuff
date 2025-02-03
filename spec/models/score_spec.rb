require 'rails_helper'

RSpec.describe Score, type: :model do
  describe "#hash" do
    it "is not related to the values" do
      expect(Score.new(win: 0, lose: 0, draw: 0).hash).not_to eq Score.new(win: 0, lose: 0, draw: 0).hash
    end
  end

  describe "#total" do
    it "returns win + lose + draw" do
      expect(Score.new(win: 4, lose: 2, draw: 3).total).to eq 9
    end
  end

  describe "#diff" do
    it "returns win - lose" do
      expect(Score.new(win: 4, lose: 2, draw: 3).diff).to eq 2
    end
  end

  describe "#win_ratio" do
    it "returns win percentage" do
      expect(Score.new(win: 7, lose: 3, draw: 1).win_ratio).to be_within(0.1).of(63.63)
    end
  end

  describe "#+" do
    it "returns a new Score with the sum of the values" do
      score_a = Score.new(win: 8, lose: 3, draw: 1)
      score_b = Score.new(win: 1, lose: 5, draw: 4)
      expect(score_a + score_b).to eq Score.new(win: 9, lose: 8, draw: 5)
    end
  end

  describe "#~" do
    it "returns a new Score inverting win and lose" do
      expect(~Score.new(win: 1, lose: 2, draw: 3)).to eq Score.new(win: 2, lose: 1, draw: 3)
    end
  end
end
