require 'rails_helper'

RSpec.describe Fighter::Synchronization do
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
    let(:battles_synchronzier) { instance_double Fighter::Synchronization::BattlesSynchronizer, { synchronize!: synchronized_battles } }
    let(:profile_synchronzier) { instance_double Fighter::Synchronization::ProfileSynchronizer, { synchronize!: nil } }
    let(:synchronized_battles) { create_list(:battle, 3) }

    before do
      allow(Fighter::Synchronization::BattlesSynchronizer).to receive(:new).and_return(battles_synchronzier)
      allow(Fighter::Synchronization::ProfileSynchronizer).to receive(:new).and_return(profile_synchronzier)
    end

    context "when synchronization succeeded" do
      it "sets status to success" do
        expect { fighter_synchronization.process! }.to change(fighter_synchronization, :status).to("success")
      end

      it "synchronizes fighter profile" do
        fighter_synchronization.process!
        expect(profile_synchronzier).to have_received(:synchronize!)
      end

      it "synchronizes fighter battles" do
        expect { fighter_synchronization.process! }.to change(fighter_synchronization, :synchronized_battles).to(synchronized_battles)
      end
    end

    context "when synchronization fails" do
      before do
        allow(battles_synchronzier).to receive(:synchronize!).and_raise("boom")
      end

      it "raises the error" do
        expect { fighter_synchronization.process! }.to raise_error("boom")
      end

      it "sets the status to failure" do
        fighter_synchronization.process! rescue nil
        expect(fighter_synchronization).to be_failure
      end

      it "sets the error to error class name" do
        fighter_synchronization.process! rescue nil
        expect(fighter_synchronization.error).to eq "RuntimeError"
      end
    end
  end
end
