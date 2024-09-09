require "rails_helper"

RSpec.describe Synchronizer do
  subject(:synchronizer) { described_class.new(short_id:, buckler:) }

  let(:short_id) { generate(:short_id) }
  let(:buckler) { instance_double Buckler }
  let(:battle_list) { build_list(:battle, 5) }
  let(:fighter_banner) { build(:fighter_banner, short_id:, main_character: 2, name: "Player Test") }

  describe "#synchronize!" do
    before do
      freeze_time
      allow(buckler).to receive(:battle_list).and_return(battle_list)
      allow(buckler).to receive(:fighter_banner).and_return(fighter_banner)
    end

    it "synchronizes player data" do
      synchronizer.synchronize!
      expect(Player.find_by(short_id:)).to have_attributes(
        name: "Player Test",
        main_character: 2,
        synchronized_at: Time.zone.now
      )
    end

    it "imports the new battles" do
      expect { synchronizer.synchronize! }.to change(Battle, :count).by 5
    end

    context "when it finds a battle already imported by the opponent" do
      before { battle_list[2].dup.save! }

      it "ignores the imported battle and imports the others" do
        expect { synchronizer.synchronize! }.to change(Battle, :count).by 4
      end
    end

    context "when it finds the latest_replay_id" do
      before do
        create(:player, short_id:, latest_replay_id: battle_list[2][:replay_id])
        battle_list[2].save!
      end

      it "stops to import when reach the latest_replay_id" do
        expect { synchronizer.synchronize! }.to change(Battle, :count).by 2
      end
    end
  end
end
