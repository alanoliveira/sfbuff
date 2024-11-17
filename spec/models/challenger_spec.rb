require "rails_helper"

RSpec.describe Challenger, type: :model do
  it { expect(Challenger.new(league_point: 0)).to be_rookie }
  it { expect(Challenger.new(league_point: 9000)).to be_gold }
  it { expect(Challenger.new(league_point: 25000)).to be_master }
  it { expect(Challenger.new(league_point: -1)).to be_calibrating }
  it { expect(Challenger.new(league_point: 1)).not_to be_calibrating }

  context "when mr was reseted" do
    subject(:challenger) { Challenger.new(league_point: 25000, master_rating: 0) }

    it { is_expected.to be_mr_reseted }
    it { expect(challenger.actual_master_rating).to eq Buckler::INITIAL_MASTER_RATING }
  end
end
