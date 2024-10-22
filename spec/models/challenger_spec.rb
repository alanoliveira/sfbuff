require "rails_helper"

RSpec.describe Challenger, type: :model do
  it { expect(Challenger.new(league_point: 0)).to be_rookie }
  it { expect(Challenger.new(league_point: 9000)).to be_gold }
  it { expect(Challenger.new(league_point: 25000)).to be_master }
  it { expect(Challenger.new(league_point: -1)).to be_calibrating }
  it { expect(Challenger.new(league_point: 1)).not_to be_calibrating }

  describe "#result" do
    it { expect(create(:battle, p1: build(:p1, :win), p2: build(:p2, :lose)).challengers.p1.result).to be_win }
    it { expect(create(:battle, p1: build(:p1, :lose), p2: build(:p2, :win)).challengers.p1.result).to be_lose }
    it { expect(create(:battle, p1: build(:p1, :draw), p2: build(:p2, :draw)).challengers.p1.result).to be_draw }
  end
end
