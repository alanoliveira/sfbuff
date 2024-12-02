require "rails_helper"

RSpec.describe PlayerSynchronizer do
  let(:player) { build(:player) }

  def run_service
    described_class.run(player:)
  end

  before do
    freeze_time
    fighter_banner = build(:fighter_banner, short_id: player.short_id.to_i, main_character: 2, name: "Sync Player")
    allow(FighterBanner).to receive(:find).with(player.short_id).and_return(fighter_banner)
    allow(BattlesSynchronizer).to receive(:run)
  end

  shared_examples "save with expected attributes" do
    it "save the player with the expected attributes" do
      run_service
      expect(player.reload.attributes_for_database).to include(
        "name" => "Sync Player", "main_character" => 2, "synchronized_at" => Time.zone.now, "latest_replay_id" => player.latest_replay_id)
    end

    it "runs the BattlesSynchronizer" do
      run_service
      expect(BattlesSynchronizer).to have_received(:run).with(player:)
    end
  end

  context "when the player exists and is not synchronized" do
    before do
      player.save
      allow(player).to receive(:synchronized?).and_return(false)
    end

    include_examples "save with expected attributes"
  end

  context "when the player exists and is synchronized" do
    before do
      player.save
      allow(player).to receive(:synchronized?).and_return(true)
    end

    it { expect { run_service }.not_to change(player, :updated_at) }
  end

  context "when the player is new" do
    it "creates a new player" do
      expect { run_service }.to change(Player, :count).by(1)
    end

    include_examples "save with expected attributes"
  end

  context "when importing same player concurrently", :slow do
    self.use_transactional_tests = false

    after { Player.destroy_all }

    it "runs synchronized" do
      allow(FighterBanner).to receive(:find) do |short_id|
        sleep 0.1
        build(:fighter_banner, short_id:)
      end

      player1 = create(:player)
      player2 = create(:player)
      [
        Thread.new { described_class.run(player: player1) },
        Thread.new { described_class.run(player: player2) },
        Thread.new { described_class.run(player: player1) }
      ].each(&:join)

      expect(FighterBanner).to have_received(:find).with(player1.short_id).exactly(1).time
      expect(FighterBanner).to have_received(:find).with(player2.short_id).exactly(1).time
    end
  end
end
