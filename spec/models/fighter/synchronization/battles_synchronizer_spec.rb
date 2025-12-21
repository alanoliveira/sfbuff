require 'rails_helper'

RSpec.describe Fighter::Synchronization::BattlesSynchronizer do
  let(:battles_synchronizer) { described_class.new(fighter) }
  let(:fighter) { create(:fighter) }

  describe "#synchronize!" do
    let(:replays) { 5.times.map { instance_double(BucklerApiGateway::Mappers::Replay, replay_id: generate(:replay_id)) } }

    before do
      allow(BucklerApiGateway).to receive(:fetch_fighter_replays).and_return(replays.lazy)
      allow(Battle).to receive(:create_or_find_by) { |replay_id:| Battle.find_by(replay_id:) || create(:battle, replay_id:) }
    end

    it "save new battles" do
      expect { battles_synchronizer.synchronize! }.to change(Battle, :count).by(5)
    end

    context "when it finds the fighter's last imported battle" do
      before do
        create(:fighter_synchronization, fighter:, synchronized_battles: [ create(:battle, replay_id: replays[3].replay_id) ])
      end

      it "stops to import" do
        expect { battles_synchronizer.synchronize! }.to change(Battle, :count).by(3)
      end
    end
  end
end
