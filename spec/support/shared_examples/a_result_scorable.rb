require 'rails_helper'

RSpec.shared_examples 'a ResultScorable' do
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

  let(:scores) do
    scorable
      .merge(Challenger.where(short_id: 1234567890).join_vs)
      .group(vs: [ :short_id ])
      .scores
  end

  it do
    expect(scores.to_a).to match([
      [ {}, an_object_having_attributes(total: 3, win: 3, lose: 0, draw: 0, diff: 3) ],
      [ {}, an_object_having_attributes(total: 2, win: 0, lose: 2, draw: 0, diff: -2) ],
      [ {}, an_object_having_attributes(total: 8, win: 3, lose: 3, draw: 2, diff: 0) ]
    ])
  end

  context "when selecting additional data" do
    let(:scores) do
      scorable
        .merge(Challenger.where(short_id: 1234567890).join_vs)
        .group(vs: [ :short_id ])
        .select(vs: [ :short_id ])
        .scores
    end

    it do
      expect(scores).to match([
        [ { "short_id" => 1234567891 }, an_object_having_attributes(total: 3, win: 3, lose: 0, draw: 0, diff: 3) ],
        [ { "short_id" => 1234567892 }, an_object_having_attributes(total: 2, win: 0, lose: 2, draw: 0, diff: -2) ],
        [ { "short_id" => 1234567893 }, an_object_having_attributes(total: 8, win: 3, lose: 3, draw: 2, diff: 0) ]
      ])
    end
  end
end
