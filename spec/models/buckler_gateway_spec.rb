require "rails_helper"

RSpec.describe BucklerGateway do
  subject(:gateway) { described_class.new(buckler_credential:) }

  let(:buckler_credential) do
    instance_double(BucklerCredential).tap do
      allow(it).to receive(:with_client).and_yield(mock_client)
    end
  end

  let(:mock_client) do
    instance_double(BucklerApi::Client,
      fighter: instance_double(BucklerApi::Client::Fighter)
    )
  end

  describe "#search_fighter_profile" do
    let(:query) { "query" }

    before do
      allow(mock_client.fighter).to receive(:search).with(short_id: query, fighter_id: nil).and_return([ "id_result" ])
      allow(mock_client.fighter).to receive(:search).with(short_id: nil, fighter_id: query).and_return([ "name_result" ])
      allow(BucklerGateway::FighterProfileParser).to receive(:parse) { "parsed #{it}" }
    end

    it "can search using short_id" do
      result = gateway.search_fighter_profile(fighter_id: query)
      expect(result).to eq([ "parsed id_result" ])
    end

    it "can search using fighter_id" do
      result = gateway.search_fighter_profile(name: query)
      expect(result).to eq([ "parsed name_result" ])
    end

    it "can not search using both short_id and fighter_id" do
      expect do
        gateway.search_fighter_profile(short_id: query, fighter_id: query)
      end.to raise_error(ArgumentError)
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
