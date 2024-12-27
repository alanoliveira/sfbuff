require "rails_helper"

RSpec.describe PlayerSynchronizer do
  subject(:service) { described_class.new(player:) }

  let(:player) { create(:player) }
  let(:new_battles) { [] }

  before do
    freeze_time
    allow(PlayerSynchronizer::BattlesSynchronizer).to receive(:run).with(player:).and_return(new_battles)
    allow(PlayerSynchronizer::ProfileSynchronizer).to receive(:run).with(player:)
  end

  it "update player synchronized_at" do
    expect { service.run }.to change(player, :synchronized_at).to(Time.zone.now)
  end

  context "when there is no new battle" do
    let(:player) { create(:player, latest_replay_id: "ASDFGH") }
    let(:new_battles) { [] }

    it "set imported_battles_count to 0" do
      service.run
      expect(service.imported_battles_count).to eq 0
    end

    it "does not change player.latest_replay_id" do
      expect { service.run }.not_to change(player, :latest_replay_id)
    end
  end

  context "when there are new battles" do
    let(:player) { create(:player, latest_replay_id: "ASDFGH") }
    let(:new_battles) { create_list(:battle, 3) }

    it "set imported_battles_count to the new battles length" do
      service.run
      expect(service.imported_battles_count).to eq 3
    end

    it "changes player.latest_replay_id to the first new battle" do
      expect { service.run }.to change(player, :latest_replay_id).to(new_battles.first.replay_id)
    end
  end
end
