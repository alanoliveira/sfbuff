require 'rails_helper'

RSpec.describe Fighter::Synchronization::ProfileSynchronizer do
  let(:profile_synchronizer) { described_class.new(fighter) }
  let(:fighter) { create(:fighter) }

  describe "#synchronize" do
    let(:play_profile) { instance_double BucklerApiGateway::Mappers::PlayProfile, character_league_infos:, fighter_banner: spy }
    let(:character_league_infos) { [ instance_double(BucklerApiGateway::Mappers::CharacterLeagueInfo, character_id: 1, master_rating: 100, league_point: 2000) ] }

    before do
      allow(BucklerApiGateway).to receive(:fetch_fighter_play_profile).and_return(play_profile)
      allow(fighter).to receive(:from_fighter_banner).with(play_profile.fighter_banner) do
        profile_synchronizer.fighter.name = "NewName"
        profile_synchronizer.fighter
      end
    end

    it "updates fighter data" do
      expect { profile_synchronizer.synchronize }.to change(profile_synchronizer.fighter, :name).to("NewName")
    end

    it "updates fighter current_leagues" do
      expect { profile_synchronizer.synchronize }.to change { fighter.current_leagues[1] }
        .to an_object_having_attributes(mr: 100, lp: 2000)
    end
  end
end
