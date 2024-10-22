require "rails_helper"

RSpec.describe Battle, type: :model do
  it { expect(create(:battle, :ranked, p1: create(:p1, :master), p2: create(:p2, :master))).to be_a_master_battle }
  it { expect(create(:battle, :battle_hub, p1: create(:p1, :master), p2: create(:p2, :master))).not_to be_a_master_battle }
  it { expect(create(:battle, :ranked, p1: create(:p1, :diamond), p2: create(:p2, :master))).not_to be_a_master_battle }

  describe "#winner_side" do
    it { expect(create(:battle, :ranked, p1: create(:p1, :win), p2: create(:p2, :lose)).winner_side).to eq "p1" }
    it { expect(create(:battle, :ranked, p1: create(:p1, :lose), p2: create(:p2, :win)).winner_side).to eq "p2" }
    it { expect(create(:battle, :ranked, p1: create(:p1, :draw), p2: create(:p2, :draw)).winner_side).to be_nil }
  end
end
