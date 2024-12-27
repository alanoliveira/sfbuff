require "rails_helper"

RSpec.describe Player, type: :model do
  before do
    described_class.synchronized_threshold = 10.minutes
  end

  it { expect(Player.new(synchronized_at: 9.minutes.ago)).to be_synchronized }
  it { expect(Player.new(synchronized_at: 11.minutes.ago)).not_to be_synchronized }
  it { expect(Player.new(synchronized_at: nil)).not_to be_synchronized }

  describe ".find_or_create" do
    subject(:player) { described_class.find_or_create(short_id) }

    let(:short_id) { generate(:short_id) }

    context "when the player with the given short_id is new" do
      it "creates the player" do
        expect(player).to be_previously_new_record
      end
    end

    context "when the player with the given short_id already exists" do
      before { create(:player, short_id:) }

      it "return the existent player" do
        expect(player).not_to be_previously_new_record
      end
    end
  end
end
