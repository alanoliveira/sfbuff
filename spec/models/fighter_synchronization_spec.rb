require 'rails_helper'

RSpec.describe FighterSynchronization do
  let(:fighter_synchronization) { described_class.create(fighter:) }
  let(:fighter) { create(:fighter) }
  let(:play_profile) { instance_double BucklerApiGateway::Mappers::PlayProfile, character_league_infos: [], fighter_banner: spy }
  let(:replays) { 5.times.map { instance_double(BucklerApiGateway::Mappers::Replay, replay_id: generate(:replay_id)) } }

  before do
    allow(BucklerApiGateway).to receive_messages(
      fetch_fighter_play_profile: play_profile,
      fetch_fighter_replays: replays
    )
  end

  describe "#process!" do
    before do
      allow(fighter_synchronization).to receive(:with_lock).and_yield # prevent reload the model
      allow(Battle).to receive(:create_or_find_by) { |replay_id:| Battle.find_by(replay_id:) || create(:battle, replay_id:) }
      allow(fighter_synchronization.fighter).to receive(:from_fighter_banner).with(play_profile.fighter_banner) do
        fighter_synchronization.fighter.name = "NewName"
        fighter_synchronization.fighter
      end
    end

    it "updates fighter data" do
      expect { fighter_synchronization.process! }.to change(fighter_synchronization.fighter, :name).to("NewName")
    end

    it "save new battles" do
      expect { fighter_synchronization.process! }.to change(fighter_synchronization.synchronized_battles, :count).to(5)
    end

    context "when it finds the last imported battle" do
      before do
        create(:fighter_synchronization, fighter:, synchronized_battles: [ create(:battle, replay_id: replays[3].replay_id) ])
      end

      it "stops to import" do
        expect { fighter_synchronization.process! }.to change(fighter_synchronization.synchronized_battles, :count).to(3)
      end
    end
  end
end
