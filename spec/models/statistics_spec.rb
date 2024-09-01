require 'rails_helper'

RSpec.describe Statistics do
  subject(:statistics) { described_class.new(relation) }

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

    let(:relation) do
      Battle.joins(:challengers)
        .merge(Challenger.where(short_id: 1234567890).join_vs)
        .group(vs: [ :short_id ])
    end

  it do
    expect(statistics).to match([
      { score: an_object_having_attributes(total: 3, win: 3, lose: 0, draw: 0, diff: 3), values: {} },
      { score: an_object_having_attributes(total: 2, win: 0, lose: 2, draw: 0, diff: -2), values: {} },
      { score: an_object_having_attributes(total: 8, win: 3, lose: 3, draw: 2, diff: 0), values: {} }
    ])
  end

  context "when there is no data" do
    let(:relation) do
      Battle.joins(:challengers)
        .merge(Challenger.where(short_id: 1234567894).join_vs)
        .group(vs: [ :short_id ])
    end

    it { expect(statistics.to_a).to be_empty }
  end

  context "when selecting additional data" do
    let(:relation) do
      Battle.joins(:challengers)
        .merge(Challenger.where(short_id: 1234567890).join_vs)
        .group(vs: [ :short_id ])
        .select(vs: [ :short_id ])
    end

    it do
      expect(statistics).to match([
        { score: an_object_having_attributes(total: 3, win: 3, lose: 0, draw: 0, diff: 3), values: { "short_id" => 1234567891 } },
        { score: an_object_having_attributes(total: 2, win: 0, lose: 2, draw: 0, diff: -2), values: { "short_id" => 1234567892 } },
        { score: an_object_having_attributes(total: 8, win: 3, lose: 3, draw: 2, diff: 0), values: { "short_id" => 1234567893 } }
      ])
    end
  end
end
