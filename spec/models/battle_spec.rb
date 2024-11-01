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

  describe "#mr_calculator" do
    subject(:mr_calculator) { battle.mr_calculator }

    context "when it is a ranked match and both players are masters" do
      let(:battle) { create(:battle, :ranked, p1: create(:p1, :master), p2: create(:p2, :master)) }
      it { is_expected.to be_a(Battle::MrCalculator) }
    end

    context "when it is not a ranked match" do
      let(:battle) { create(:battle, :custom_room, p1: create(:p1, :master), p2: create(:p2, :master)) }
      it { is_expected.to be_nil }
    end

    context "when it is a ranked match and at least one of the players is not masters" do
      let(:battle) { create(:battle, :ranked, p1: create(:p1, :diamond), p2: create(:p2, :master)) }
      it { is_expected.to be_nil }
    end

   context "when it is a ranked match and at least one of the players is calibrating MR" do
      let(:battle) { create(:battle, :ranked, p1: create(:p1, :master, master_rating: 0), p2: create(:p2, :master)) }
      it { is_expected.to be_nil }
    end
  end
end
