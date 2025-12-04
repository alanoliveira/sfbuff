require 'rails_helper'

RSpec.describe FighterSynchronization do
  let(:fighter_synchronization) { described_class.create(fighter:) }
  let(:fighter) { create(:fighter) }

  describe ".unfinished" do
    before do
      described_class.statuses.keys.each { create(:fighter_synchronization, it, fighter:) }
    end

    it do
      expect(described_class.unfinished).to have_attributes(count: 2).and all be_unfinished
    end
  end

  describe "#process!" do
    let(:play_profile) { instance_double BucklerApiGateway::Mappers::PlayProfile, character_league_infos:, fighter_banner: spy }
    let(:character_league_infos) { [ instance_double(BucklerApiGateway::Mappers::CharacterLeagueInfo, character_id: 1, master_rating: 100, league_point: 2000) ] }
    let(:replays) { 5.times.map { instance_double(BucklerApiGateway::Mappers::Replay, replay_id: generate(:replay_id)) } }

    before do
      allow(BucklerApiGateway).to receive_messages(
        fetch_fighter_play_profile: play_profile,
        fetch_fighter_replays: replays
      )
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

    it "updates fighter current_league_infos" do
      expect { fighter_synchronization.process! }.to change { fighter.current_league_infos[1] }
        .to an_object_having_attributes(mr: 100, lp: 2000)
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
