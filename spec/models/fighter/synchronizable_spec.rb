require "rails_helper"

RSpec.describe Fighter::Synchronizable do
  let(:fighter) { create(:fighter) }

  describe "#synchronized?" do
    subject(:synchronized) { fighter.synchronized? }

    context "when the fighter last synchronization is older then or equal SYNCHRONIZATION_INTERVAL ago" do
      before { create(:fighter_synchronization, :success, fighter:, created_at: Fighter.synchronization_interval.ago) }

      it { is_expected.to be_falsey }
    end

    context "when the fighter last synchronization is newer then SYNCHRONIZATION_INTERVAL ago" do
      before { create(:fighter_synchronization, :success, fighter:, created_at: (Fighter.synchronization_interval - 1).ago) }

      it { is_expected.to be_truthy }
    end

    context "when there is no last synchronization" do
      it { is_expected.to be_falsey }
    end
  end

  describe "#synchronizing?" do
    subject(:synchronizing) { fighter.synchronizing? }

    context "when the last synchronization is not finished" do
      before { create(:fighter_synchronization, :created, fighter:) }

      it { is_expected.to be_truthy }
    end

    context "when the last synchronization is finished" do
      before { create(:fighter_synchronization, :success, fighter:) }

      it { is_expected.to be_falsey }
    end

    context "when there is no last synchronization" do
      it { is_expected.to be_falsey }
    end
  end
end
