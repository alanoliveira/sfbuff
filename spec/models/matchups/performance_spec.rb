require "rails_helper"

RSpec.describe Matchup::Performance do
  let(:performance) { Matchup.where_home(short_id: 1234567890).performance }

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

  describe "#sum" do
    let(:sum) { performance.sum }

    it do
      expect(sum).to have_attributes(total: 13, win: 6, lose: 5, draw: 2, diff: 1)
    end
  end
end
