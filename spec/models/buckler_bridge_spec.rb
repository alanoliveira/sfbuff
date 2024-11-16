require "rails_helper"

RSpec.describe BucklerBridge do
  subject(:buckler_bridge) do
    described_class.new(next_client: next_client)
  end

  let(:next_client) { instance_double(Buckler::Api::NextClient) }

  before do
    allow(Parsers::BattleParser).to receive(:parse) { _1[:raw_data] + 1 }
    allow(Parsers::FighterBannerParser).to receive(:parse) { _1[:raw_data] + 1 }
  end

  describe "#search_fighter_banner" do
    context "when it finds some results" do
      it "returns the parsed data" do
        allow(next_client).to receive(:search_fighter_banner).with('player').and_return([ 1, 2 ])

        expect(buckler_bridge.search_fighter_banner(term: 'player')).to eq [ 2, 3 ]
      end
    end

    context "when it does not find any results" do
      it "returns an empty array" do
        allow(next_client).to receive(:search_fighter_banner).and_return([])

        expect(buckler_bridge.search_fighter_banner(term: 'player_x')).to eq []
      end
    end
  end

  describe "#fighter_banner" do
    context "when it finds the player" do
      it do
        allow(next_client).to receive(:find_fighter_banner).with('123456789').and_return(1)

        expect(buckler_bridge.fighter_banner(short_id: '123456789')).to eq 2
      end
    end

    context "when it does not find the player" do
      it do
        allow(next_client).to receive(:find_fighter_banner).with('123456788').and_return(nil)

        expect { buckler_bridge.fighter_banner(short_id: '123456788') }.to raise_error BucklerBridge::PlayerNotFound
      end
    end
  end

  describe "#battle_list" do
    it "it finds the player battlelog" do
      allow(next_client).to receive(:battle_list).with('123456789').and_return([ 1, 2, 3 ].to_enum)

      expect(buckler_bridge.battle_list(short_id: '123456789')).to be_a(Enumerable)
      .and match([ 2, 3, 4 ])
    end
  end
end
