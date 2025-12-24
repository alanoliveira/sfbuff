require 'rails_helper'

RSpec.describe FighterSearch do
  let(:fighter_search) { described_class.new(query: "player") }

  describe "#process" do
    before do
      fighter_search.update(query:)
      allow(BucklerApiGateway).to receive(:search_fighter_banners).with(short_id: query).and_return([ "short_id_result" ])
      allow(BucklerApiGateway).to receive(:search_fighter_banners).with(fighter_id: query).and_return([ "fighter_id_result" ])
    end

    context "when query is a short_id" do
      let(:query) { generate(:short_id).to_s }

      it "returns results searching by fighter_id and short_id" do
        expect { fighter_search.process }.to change(fighter_search, :result).to([ "short_id_result", "fighter_id_result" ])
      end
    end

    context "when query not is a short_id" do
      let(:query) { "player" }

      it "returns results only searching by fighter_id" do
        expect { fighter_search.process }.to change(fighter_search, :result).to([ "fighter_id_result" ])
      end
    end
  end
end
