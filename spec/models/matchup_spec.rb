require 'rails_helper'

RSpec.describe Matchup do
  subject(:matchup) { described_class.where(home: { side: 1 }, away: { side: 2 }) }

  it "can filter by 'home' challenger" do
    create(:battle, p1: build(:p1, character: 1), p2: build(:p2, character: 6))
    create(:battle, p1: build(:p1, character: 1), p2: build(:p2, character: 3))
    create(:battle, p1: build(:p1, character: 4), p2: build(:p2, character: 1))

    expect(matchup.where(home: { character: 1 })).to have_attributes(count: 2)
  end

  it "can filter by 'away' challenger" do
    create(:battle, p1: build(:p1, character: 1), p2: build(:p2, character: 6))
    create(:battle, p1: build(:p1, character: 1), p2: build(:p2, character: 3))
    create(:battle, p1: build(:p1, character: 4), p2: build(:p2, character: 1))

    expect(matchup.where(away: { character: 1 })).to have_attributes(count: 1)
  end

  describe "#index_with_result" do
    subject(:indexed_results) { matchup.where(home: { side: 1 }).index_with_result }

    it do
      b1 = create(:battle, p1: build(:p1, :win), p2: build(:p2, :lose))
      b2 = create(:battle, p1: build(:p1, :lose), p2: build(:p2, :win))
      b3 = create(:battle, p1: build(:p1, :draw), p2: build(:p2, :draw))

      expect(indexed_results).to match(b1 => "win", b2 => "lose", b3 => "draw")
    end

    context "using limit + offset" do
      subject(:indexed_results) do
        matchup.where(home: { side: 1 }).limit(1).offset(1).index_with_result
      end

      it do
        b1 = create(:battle, p1: build(:p1, :win), p2: build(:p2, :lose))
        b2 = create(:battle, p1: build(:p1, :lose), p2: build(:p2, :win))
        b3 = create(:battle, p1: build(:p1, :draw), p2: build(:p2, :draw))

        expect(indexed_results).to match(b2 => "lose")
      end
    end
  end
end
