require "rails_helper"

RSpec.describe Matchup, type: :model do
  describe "#result" do
    subject(:result) { described_class.find_by(battle_id: battle.id, "home_challenger.side" => "p1").result }

    context "when home_challenger win" do
      let(:battle) { create(:battle, p1: build(:p1, :win), p2: build(:p2, :lose)) }

      it { is_expected.to eq "win" }
    end

    context "when home_challenger lose" do
      let(:battle) { create(:battle, p1: build(:p1, :lose), p2: build(:p2, :win)) }

      it { is_expected.to eq "lose" }
    end

    context "when draw" do
      let(:battle) { create(:battle, p1: build(:p1, :draw), p2: build(:p2, :draw)) }

      it { is_expected.to eq "draw" }
    end
  end
end
