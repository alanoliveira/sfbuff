require 'rails_helper'

RSpec.describe Fighter::Synchronizer::BattlesSynchronizer do
  subject(:synchronizer) { described_class.new(fighter) }

  let(:fighter) { create(:fighter) }

  before do
    allow(BucklerGateway).to receive(:fetch_fighter_battles).with(fighter.id, anything).and_return([])
  end

  describe "#synchronize" do
    context "when there is no new battle" do
      it "does not change the fighter last_synchronized_replay_id" do
        expect { synchronizer.synchronize }.not_to change(fighter, :last_synchronized_replay_id)
      end
    end

    context "when there are new battles" do
      let(:new_battles) { build_list(:battle, 3, p1: build(:challenger, fighter_id: fighter.id)) }

      before do
        allow(BucklerGateway).to receive(:fetch_fighter_battles).with(fighter.id, 1).and_return(new_battles)
      end

      it "saves the new battles" do
        expect { synchronizer.synchronize }.to change(Battle, :count).by(3)
      end

      it "changes the fighter last_synchronized_replay_id" do
        expect { synchronizer.synchronize }.to change(fighter, :last_synchronized_replay_id)
          .to(new_battles.first.replay_id)
      end
    end

    context "when it finds a battle already imported by the opponent" do
      let(:new_battles) { build_list(:battle, 3, p1: build(:challenger, fighter_id: fighter.id)) }

      before do
        allow(BucklerGateway).to receive(:fetch_fighter_battles).with(fighter.id, 1).and_return(new_battles)
        new_battles[0].clone.save!
      end

      it "ignores it and import the others" do
        expect { synchronizer.synchronize }.to change(Battle, :count).by(2)
      end

      it "changes the fighter last_synchronized_replay_id even if it is the already imported battle" do
        expect { synchronizer.synchronize }.to change(fighter, :last_synchronized_replay_id)
          .to(new_battles.first.replay_id)
      end
    end

    context "when it finds the battle with replay_id equals to last_synchronized_replay_id" do
      let(:new_battles) { build_list(:battle, 3, p1: build(:challenger, fighter_id: fighter.id)) }

      before do
        allow(BucklerGateway).to receive(:fetch_fighter_battles).with(fighter.id, 1).and_return(new_battles)
        fighter.update(last_synchronized_replay_id: new_battles[1].replay_id)
      end

      it "stops to import" do
        expect { synchronizer.synchronize }.to change(Battle, :count).by(1)
      end
    end
  end
end
