require "rails_helper"

RSpec.describe Challenger, type: :model do
  it { expect(Challenger.new(league_point: 0)).to be_rookie }
  it { expect(Challenger.new(league_point: 9000)).to be_gold }
  it { expect(Challenger.new(league_point: 25000)).to be_master }
  it { expect(Challenger.new(league_point: -1)).to be_calibrating }
  it { expect(Challenger.new(league_point: 1)).not_to be_calibrating }

  describe "#vs" do
    let(:p1) { build(:p1, battle: nil)  }
    let(:p2) { build(:p2, battle: nil)  }
    before { create(:battle, p1:, p2:) }

    it { expect(p1.vs).to eq p2 }
    it { expect(p2.vs).to eq p1 }
  end

  describe "#result" do
    it { expect(create(:p1, rounds: [ 1 ])).to be_win }
    it { expect(create(:p1, rounds: [ 0 ])).to be_lose }
    it { expect(create(:p1, rounds: [ 4 ])).to be_draw }
  end
end
