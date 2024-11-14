require 'rails_helper'

RSpec.describe Matchup do
  subject(:matchup) { described_class.where_home(side: 1).where_away(side: 2) }

  describe "#where_home" do
    it "can filter by 'home' challenger" do
      create(:battle, p1: build(:p1, character: 1), p2: build(:p2, character: 6))
      create(:battle, p1: build(:p1, character: 1), p2: build(:p2, character: 3))
      create(:battle, p1: build(:p1, character: 4), p2: build(:p2, character: 1))

      expect(matchup.where_home(character: 1)).to have_attributes(count: 2)
    end
  end

  describe "#where_away" do
    it "can filter by 'away' challenger" do
      create(:battle, p1: build(:p1, character: 1), p2: build(:p2, character: 6))
      create(:battle, p1: build(:p1, character: 1), p2: build(:p2, character: 3))
      create(:battle, p1: build(:p1, character: 4), p2: build(:p2, character: 1))

      expect(matchup.where_away(character: 1)).to have_attributes(count: 1)
    end
  end

  describe "#index_with_result" do
    subject(:indexed_results) { matchup.where_home(side: 1).index_with_result }

    it do
      b1 = create(:battle, p1: build(:p1, :win), p2: build(:p2, :lose))
      b2 = create(:battle, p1: build(:p1, :lose), p2: build(:p2, :win))
      b3 = create(:battle, p1: build(:p1, :draw), p2: build(:p2, :draw))

      expect(indexed_results).to match(b1 => "win", b2 => "lose", b3 => "draw")
    end
  end
end
