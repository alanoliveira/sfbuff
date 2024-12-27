require "rails_helper"

RSpec.describe PlayerSynchronizer::ProfileSynchronizer do
  subject(:service) { described_class.new(player:) }

  let(:player) { create(:player) }

  def run_service
    described_class.run(player:)
  end

  before do
    freeze_time
    fighter_banner = build(:fighter_banner, short_id: player.short_id.to_i, main_character: 2, name: "Sync Player")
    allow(FighterBanner).to receive(:find!).with(player.short_id).and_return(fighter_banner)
  end

  it "set player attributes" do
    run_service
    expect(player).to have_attributes("name" => "Sync Player", "main_character" => 2)
  end
end
