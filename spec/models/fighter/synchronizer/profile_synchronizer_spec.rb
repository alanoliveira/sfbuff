require 'rails_helper'

RSpec.describe Fighter::Synchronizer::ProfileSynchronizer do
  subject(:synchronizer) { described_class.new(fighter, buckler_gateway) }

  let(:fighter) { create(:fighter) }
  let(:buckler_gateway) { instance_double(BucklerGateway) }

  describe "#synchronize" do
    before { allow(buckler_gateway).to receive(:find_fighter_profile).with(fighter.id).and_return(profile) }

    context "when the profile is found" do
      let(:profile) { attributes_for(:fighter_profile, name: "Sync") }

      it "updates buckler_data" do
        expect { synchronizer.synchronize }.to change(fighter, :profile).to an_object_having_attributes(name: "Sync")
      end
    end

    context "when the profile is not found" do
      let(:profile) { nil }

      it do
        expect { synchronizer.synchronize }.to raise_error(Fighter::Synchronizer::ProfileNotFound)
      end
    end
  end
end
