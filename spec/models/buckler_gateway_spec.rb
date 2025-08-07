require "rails_helper"

RSpec.describe BucklerGateway do
  subject(:gateway) { described_class.new }

  let(:mock_client) do
    instance_double(
      BucklerApi::Client,
      fighter: instance_double(BucklerApi::Client::Fighter)
    )
  end

  before do
    buckler_credential = instance_double(BucklerCredential)
    allow(buckler_credential).to receive(:with_client).and_yield(mock_client)
    allow(BucklerCredential).to receive(:take).and_return(buckler_credential)
  end

  describe "#find_fighter_profile" do
    subject(:result) { gateway.find_fighter_profile("fighter_id") }

    context "when api returns results" do
      before do
        allow(mock_client.fighter).to receive(:search).with(short_id: "fighter_id").and_return([ "fighter1" ])
        allow(BucklerGateway::FighterProfileParser).to receive(:parse) { "parsed #{it}" }
      end

      it "parses the first (and only) result and return it" do
        expect(result).to eq "parsed fighter1"
      end
    end

    context "when api returns an empty list" do
      before do
        allow(mock_client.fighter).to receive(:search).with(short_id: "fighter_id").and_return([])
      end

      it "returns nil" do
        expect(result).to be_nil
      end
    end
  end

  describe "#search_fighter_profile" do
    subject(:result) { gateway.search_fighter_profile("query") }

    context "when api returns results" do
      before do
        allow(mock_client.fighter).to receive(:search).with(fighter_id: "query").and_return([ "fighter1", "fighter2" ])
        allow(BucklerGateway::FighterProfileParser).to receive(:parse) { "parsed #{it}" }
      end

      it "parses all the results and return it" do
        expect(result).to eq([ "parsed fighter1", "parsed fighter2" ])
      end
    end

    context "when api return an empty list" do
      before do
        allow(mock_client.fighter).to receive(:search).with(fighter_id: "query").and_return([])
      end

      it "returns an empty list" do
        expect(result).to eq([])
      end
    end
  end

  describe "#fetch_fighter_battles" do
    subject(:result) { gateway.fetch_fighter_battles("fighter_id", page) }

    let(:page) { 1 }

    context "when api returns results" do
      before do
        allow(BucklerGateway::BattleParser).to receive(:parse) { "parsed #{it}" }
        allow(mock_client.fighter).to receive(:battlelog).with("fighter_id", page).and_return([ "battle1", "battle2" ])
      end

      it "parses all the results and return it" do
        expect(result).to eq ([ "parsed battle1", "parsed battle2" ])
      end
    end

    context "when api returns an empty array" do
      before do
        allow(mock_client.fighter).to receive(:battlelog).with("fighter_id", page).and_return([])
      end

      it "returns an empty array" do
        expect(result).to eq([])
      end
    end
  end

  describe "#fetch_fighter_play_data" do
    subject(:result) { gateway.fetch_fighter_play_data("fighter_id") }

    before do
      allow(BucklerGateway::PlayDataParser).to receive(:parse).with("A") { "parsed #{it}" }
      allow(BucklerGateway::FighterProfileParser).to receive(:parse).with("B") { "parsed #{it}" }

      allow(mock_client.fighter).to receive(:play_data).with("fighter_id")
        .and_return({ "play" => "A", "fighter_banner_info" => "B" })
    end

    it { expect(result).to eq ( { play_data: "parsed A", fighter_profile: "parsed B" }) }
  end
end
