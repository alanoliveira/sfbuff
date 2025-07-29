require 'rails_helper'

RSpec.describe Fighter::Synchronizable do
  describe "#synchronize_later" do
    let(:fighter) { create(:fighter) }

    it "enqueues a Fighter::SynchronizeJob" do
      expect { fighter.synchronize_later }.to \
        have_enqueued_job(Fighter::SynchronizeJob).with(fighter)
    end
  end

  describe "#synchronize_now" do
    let(:synchronizer) { instance_double(Fighter::Synchronizer, synchronize: nil) }

    before do
      freeze_time
      allow(Fighter::Synchronizer).to receive(:new).with(fighter).and_return(synchronizer)
    end

    context "when the fighter is not synchronized" do
      let(:fighter) { create(:fighter, synchronized_at: described_class::SYNCHRONIZATION_THRESHOLD.ago) }

      it "updates player synchronized_at" do
        fighter.synchronize_now
        expect(synchronizer).to have_received(:synchronize)
      end
    end

    context "when the fighter is synchronized" do
      let(:fighter) { create(:fighter, synchronized_at: Time.now) }

      it "updates player synchronized_at" do
        fighter.synchronize_now
        expect(synchronizer).not_to have_received(:synchronize)
      end
    end
  end
end
