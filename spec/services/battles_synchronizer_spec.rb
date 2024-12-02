require "rails_helper"

RSpec.describe BattlesSynchronizer do
  let(:player) { create(:player, latest_replay_id:) }
  let(:latest_replay_id) { nil }
  let(:new_battles) { build_list(:battle, 5) }

  def run_service = described_class.run(player:)

  before do
    freeze_time
    allow(Battle).to receive(:import).with(player.short_id).and_return(new_battles)
  end

  it "imports the new battles" do
    expect { run_service }.to change(Battle, :count).by 5
  end

  context "when it finds na already imported by the opponent" do
    before do
      src = new_battles[2]
      dup_battle = src.dup
      dup_battle.challengers = src.challengers.map(&:dup)
      dup_battle.save
    end

    it "ignores it and continue" do
      expect { run_service }.to change(Battle, :count).by 4
    end
  end

  context "when it finds the palyer latest_replay_id" do
    let(:latest_replay_id) { new_battles[2].replay_id }

    it "stops to import" do
      expect { run_service }.to change(Battle, :count).by 2
    end
  end
end
