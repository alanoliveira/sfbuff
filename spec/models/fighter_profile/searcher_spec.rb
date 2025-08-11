require "rails_helper"

RSpec.describe FighterProfile::Searcher do
  let(:fighter_searcher) { described_class.new(query, buckler_gateway:) }
  let(:query) { "query" }
  let(:buckler_gateway) { instance_double(BucklerGateway) }

  before do
    allow(buckler_gateway).to receive(:search_fighter_profile).with(fighter_id: query).and_return([ 1 ])
    allow(buckler_gateway).to receive(:search_fighter_profile).with(name: query).and_return([ 2 ])
    allow(FighterProfile).to receive(:new) { "profile #{it}" }
  end

  describe "#search" do
    subject(:search) { fighter_searcher.search }

    context "when the query is not a fighter_id" do
      before { allow(query).to receive(:match?).with(Fighter::FIGHTER_ID_REGEXP).and_return false }

      it "only searches using name" do
        expect(search).to eq [ "profile 2" ]
      end
    end

    context "when the query is a fighter_id" do
      before { allow(query).to receive(:match?).with(Fighter::FIGHTER_ID_REGEXP).and_return true }

      it "only searches using name" do
        expect(search).to eq [ "profile 1", "profile 2" ]
      end
    end
  end
end
