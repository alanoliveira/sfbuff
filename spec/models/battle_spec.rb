require "rails_helper"

RSpec.describe Battle, type: :model do
  let(:battle) { create(:battle) }

  it "set winner_side before save" do
    battle = build(:battle, p1: build(:p1, :win), p2: build(:p2, :lose))
    expect { battle.save }.to change(battle, :winner_side).from(nil).to(1)
  end

  describe "#master_battle?" do
    subject(:is_master_battle) { battle.master_battle? }

    context "when it is ranked and both players are master" do
      let(:battle) { create(:battle, :ranked, p1: build(:p1, :master), p2: build(:p2, :master)) }
      it { is_expected.to be true }
    end

    context "when it is ranked but at least one of the players is not master" do
      let(:battle) { create(:battle, :ranked, p1: build(:p1, :diamond), p2: build(:p2, :master)) }
      it { is_expected.to be false }
    end

    context "when both players are master but it is not ranked" do
      let(:battle) { create(:battle, :custom_room, p1: build(:p1, :master), p2: build(:p2, :master)) }
      it { is_expected.to be false }
    end
  end

  describe "#winner" do
    subject(:winner) { create(:battle, p1: build(:p1, rounds: p1_rounds), p2: build(:p2, rounds: p2_rounds)).winner }

    context "when p1 won more rounds then p2" do
      let(:p1_rounds) { [ Round["V"] ] }
      let(:p2_rounds) { [ Round["L"] ] }

      it { is_expected.to be_p1 }
    end

    context "when p2 won more rounds then p1" do
      let(:p1_rounds) { [ Round["L"] ] }
      let(:p2_rounds) { [ Round["V"] ] }

      it { is_expected.to be_p2 }
    end

    context "when it is a draw" do
      let(:p1_rounds) { [ Round["D"] ] }
      let(:p2_rounds) { [ Round["D"] ] }

      it { is_expected.to be_nil }
    end
  end
end
