require "rails_helper"

RSpec.describe Fighter::Synchronizable do
  let(:fighter) { create(:fighter) }

  describe "#synchronized?" do
    subject(:synchronized) { fighter.synchronized? }

    context "when fighter's synchronized_at is older then or equal SYNCHRONIZATION_INTERVAL ago" do
      before { fighter.update(synchronized_at: Fighter.synchronization_interval.ago) }

      it { is_expected.to be_falsey }
    end

    context "when fighter's synchronized_at is newer then SYNCHRONIZATION_INTERVAL ago" do
      before { fighter.update(synchronized_at: (Fighter.synchronization_interval - 1).ago) }

      it { is_expected.to be_truthy }
    end

    context "when fighter's synchronized_at is nil" do
      before { fighter.update(synchronized_at: nil) }

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
