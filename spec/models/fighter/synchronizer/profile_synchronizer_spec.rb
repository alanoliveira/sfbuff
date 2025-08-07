require 'rails_helper'

RSpec.describe Fighter::Synchronizer::ProfileSynchronizer do
  subject(:synchronizer) { described_class.new(fighter, buckler_gateway) }

  let(:fighter) { create(:fighter) }
  let(:buckler_gateway) { instance_double(BucklerGateway) }

  describe "#synchronize" do
    let(:new_profile) { build(:fighter_profile) }

    before do
      response = { play_data: { character_league_infos: "league_infos" }, fighter_profile: "profile_data" }
      allow(buckler_gateway).to receive(:fetch_fighter_play_data).with(fighter.id).and_return(response)

      allow(FighterProfile).to receive(:new).with("profile_data").and_return(new_profile)
      allow(fighter).to receive(:character_league_infos).and_return(spy)
    end

    context "when the profile is found" do
      it "updates fighter's profile" do
        expect { synchronizer.synchronize }.to change(fighter, :profile).to an_object_having_attributes(new_profile.attributes)
      end

      it "updates fighter's character_league_infos" do
        synchronizer.synchronize
        expect(fighter.character_league_infos).to have_received(:upsert_all).with("league_infos")
      end
    end
  end
end
