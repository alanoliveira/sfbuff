require "rails_helper"

RSpec.describe Battle::Matchup::Performance do
  let(:performance) { Battle.matchup.where_home(short_id: 1234567890).performance }

  before do
    mik = { short_id: 1234567890, character: 1 }
    raf = { short_id: 1234567892, character: 2 }
    don = { short_id: 1234567891, character: 3 }
    leo = { short_id: 1234567893, character: 4 }
    2.times { create(:battle, p1: build(:p1, :win, **raf), p2: build(:p2, :lose, **mik)) }
    3.times { create(:battle, p1: build(:p1, :win, **mik), p2: build(:p2, :lose, **don)) }
    3.times { create(:battle, p1: build(:p1, :lose, **mik), p2: build(:p2, :win, **leo)) }
    3.times { create(:battle, p1: build(:p1, :win, **mik), p2: build(:p2, :lose, **leo)) }
    2.times { create(:battle, p1: build(:p1, :draw, **mik), p2: build(:p2, :draw, **leo)) }
  end

  describe "#score" do
    let(:score) { performance.score }

    it do
      expect(score).to have_attributes(total: 13, win: 6, lose: 5, draw: 2, diff: 1)
    end

    context "when selecting additional data" do
      let(:score) do
        performance
          .group(away: [ :short_id ])
          .select(away: [ :short_id ])
          .score
      end

      it do
        expect(score).to match([
          { { "short_id" => 1234567891 } => an_object_having_attributes(total: 3, win: 3, lose: 0, draw: 0, diff: 3) },
          { { "short_id" => 1234567892 } => an_object_having_attributes(total: 2, win: 0, lose: 2, draw: 0, diff: -2) },
          { { "short_id" => 1234567893 } => an_object_having_attributes(total: 8, win: 3, lose: 3, draw: 2, diff: 0) }
        ])
      end
    end
  end

  describe "#favorites" do
    let(:favorites) do
      performance
        .group(away: [ :short_id ])
        .favorites
    end

    it do
      expect(favorites).to match([
        { { "short_id" => 1234567893 } => an_object_having_attributes(total: 8, win: 3, lose: 3, draw: 2, diff: 0) },
        { { "short_id" => 1234567891 } => an_object_having_attributes(total: 3, win: 3, lose: 0, draw: 0, diff: 3) },
        { { "short_id" => 1234567892 } => an_object_having_attributes(total: 2, win: 0, lose: 2, draw: 0, diff: -2) }
      ])
    end
  end

  describe "#victims" do
    let(:victims) do
      performance
        .group(away: [ :short_id ])
        .victims
    end

    it do
      expect(victims).to match([
        { { "short_id" => 1234567891 } => an_object_having_attributes(total: 3, win: 3, lose: 0, draw: 0, diff: 3) },
        { { "short_id" => 1234567893 } => an_object_having_attributes(total: 8, win: 3, lose: 3, draw: 2, diff: 0) },
        { { "short_id" => 1234567892 } => an_object_having_attributes(total: 2, win: 0, lose: 2, draw: 0, diff: -2) }
      ])
    end
  end

  describe "#tormentors" do
    let(:tormentors) do
      performance
        .group(away: [ :short_id ])
        .tormentors
    end

    it do
      expect(tormentors).to match([
        { { "short_id" => 1234567892 } => an_object_having_attributes(total: 2, win: 0, lose: 2, draw: 0, diff: -2) },
        { { "short_id" => 1234567893 } => an_object_having_attributes(total: 8, win: 3, lose: 3, draw: 2, diff: 0) },
        { { "short_id" => 1234567891 } => an_object_having_attributes(total: 3, win: 3, lose: 0, draw: 0, diff: 3) }
      ])
    end
  end
end
