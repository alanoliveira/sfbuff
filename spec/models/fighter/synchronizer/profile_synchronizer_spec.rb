require 'rails_helper'

RSpec.describe Fighter::Synchronizer::ProfileSynchronizer, type: :model do
  subject(:synchronizer) { described_class.new(fighter) }

  let(:fighter) { create(:fighter) }

  before do
    allow(BucklerGateway).to receive(:find_fighter_profile!).with(fighter.id).and_return(build(:fighter_profile, name: "Sync"))
  end

  describe "#synchronize" do
    it "updates buckler_data" do
      expect { synchronizer.synchronize }.to change(fighter, :profile).to an_object_having_attributes(name: "Sync")
    end
  end
end
