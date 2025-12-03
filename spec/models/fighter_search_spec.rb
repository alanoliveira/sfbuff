require 'rails_helper'

RSpec.describe FighterSearch do
  let(:fighter_search) { described_class.new(query: "player") }

  context "when the performed_at is older then or equal refresh_interval ago" do
    before { fighter_search.update(performed_at: described_class.refresh_interval.ago) }

    it { expect(fighter_search).to be_outdated }
  end

  context "when the performed_at is newer then refresh_interval ago" do
    before { fighter_search.update(performed_at: (described_class.refresh_interval - 1).ago) }

    it { expect(fighter_search).not_to be_outdated }
  end

  context "when the performed_at is nil" do
    before { fighter_search.update(performed_at: nil) }

    it { expect(fighter_search).to be_outdated }
  end

  describe "#refresh!" do
    before do
      fighter_search.update(query:)
      allow(BucklerApiGateway).to receive(:search_fighter_banners).with(short_id: query).and_return([ "short_id_result" ])
      allow(BucklerApiGateway).to receive(:search_fighter_banners).with(fighter_id: query).and_return([ "fighter_id_result" ])
    end

    context "when query is a short_id" do
      let(:query) { generate(:short_id).to_s }

      it "returns results searching by fighter_id and short_id" do
        expect { fighter_search.refresh! }.to change(fighter_search, :result).to([ "short_id_result", "fighter_id_result" ])
      end
    end

    context "when query not is a short_id" do
      let(:query) { "player" }

      it "returns results only searching by fighter_id" do
        expect { fighter_search.refresh! }.to change(fighter_search, :result).to([ "fighter_id_result" ])
      end
    end
  end
end
