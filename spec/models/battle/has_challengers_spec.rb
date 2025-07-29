require 'rails_helper'

RSpec.describe Battle::HasChallengers do
  let(:battle) { build(:battle) }

  context "when p1 is the winner" do
    before do
      battle.p1 = build(:challenger, :win)
      battle.p2 = build(:challenger, :loss)
    end

    it { expect { battle.save }.to change(battle, :winner_side).to(1) }
  end

  context "when p2 is the winner" do
    before do
      battle.p1 = build(:challenger, :loss)
      battle.p2 = build(:challenger, :win)
    end

    it { expect { battle.save }.to change(battle, :winner_side).to(2) }
  end

  context "when it is a draw" do
    before do
      battle.p1 = build(:challenger, :draw)
      battle.p2 = build(:challenger, :draw)
    end

    it { expect { battle.save }.to change(battle, :winner_side).to(0) }
  end
end
