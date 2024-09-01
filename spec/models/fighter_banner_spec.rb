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

  describe "#as_player" do
    subject(:player) { fighter_banner.as_player }

    context "when the player is new" do
      it "build a new record" do
        expect(player).to be_new_record
          .and have_attributes(name: "Player Test",  main_character: 1)
      end
    end

    context "when the player already exists" do
      before do
        create(:player, short_id: fighter_banner.short_id)
      end

      it "alters the existent player" do
        expect(player).not_to be_new_record
        expect(player).to have_attributes(name: "Player Test",  main_character: 1)
      end
    end
  end
end
