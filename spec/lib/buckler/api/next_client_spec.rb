require "rails_helper"

RSpec.describe Buckler::Api::NextClient do
  subject(:next_client) do
    described_class.new(next_api)
  end

  let(:next_api) { instance_double(Buckler::Api::NextApi) }

  describe "#search_fighter_banner" do
    context "when it finds some results" do
      it "returns the parsed data" do
        allow(next_api).to receive(:fighterslist).with(fighter_id: 'player').and_return([ 1, 2 ])

        expect(next_client.search_fighter_banner('player')).to eq [ 1, 2 ]
      end
    end

    context "when it does not find any results" do
      it "returns an empty array" do
        allow(next_api).to receive(:fighterslist).and_return([])

        expect(next_client.search_fighter_banner('player_x')).to eq []
      end
    end

    context "with a term that might be a short_id" do
      it "returns the combined results of short_id and fighter_id search" do
        allow(next_api).to receive(:fighterslist).with(fighter_id: '123456789').and_return([ 3, 4 ])
        allow(next_api).to receive(:fighterslist).with(short_id: 123456789).and_return([ 5 ])

        expect(next_client.search_fighter_banner('123456789')).to eq [ 3, 4, 5 ]
      end
    end

    context "with a invalid term" do
      it { expect { next_client.search_fighter_banner(term: 'abc') }.to raise_error ArgumentError }
    end
  end

  describe "#find_fighter_banner" do
    context "when it finds the player" do
      it do
        allow(next_api).to receive(:fighterslist).with(short_id: 123456789).and_return([ 1 ])

        expect(next_client.find_fighter_banner(123456789)).to eq 1
      end
    end

    context "when it does not find the player" do
      it do
        allow(next_api).to receive(:fighterslist).with(short_id: 123456788).and_return([])

        expect(next_client.find_fighter_banner(123456788)).to be_nil
      end
    end

    context "with a invalid short_id" do
      it { expect { next_client.find_fighter_banner('1234678FOO') }.to raise_error ArgumentError }
    end
  end

  describe "#battle_list" do
    it "it finds the player battlelog" do
      allow(next_api).to receive(:battlelog).with(123456789, 1).and_return([ 1, 2 ])
      allow(next_api).to receive(:battlelog).with(123456789, 2).and_return([ 3, 4 ])
      allow(next_api).to receive(:battlelog).with(123456789, 3).and_return([])

      expect(next_client.battle_list(123456789)).to be_a(Enumerable)
      .and match([ 1, 2, 3, 4 ])
    end

    context "with a invalid short_id" do
      it { expect { next_client.battle_list(12389) }.to raise_error ArgumentError }
    end
  end
end
