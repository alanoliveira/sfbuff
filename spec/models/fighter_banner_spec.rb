require "rails_helper"

RSpec.describe FighterBanner, type: :model do
  subject(:fighter_banner) do
    described_class.new(
      short_id: generate(:short_id),
      name: "Player Test",
      main_character: 1,
      master_rating: 1000,
      league_point: 20_000,
    )
  end

  describe "#player_attributes" do
    subject(:player_attributes) { fighter_banner.player_attributes }

    it { is_expected.to match("name" => "Player Test",  "main_character" => 1) }
  end
end
