require "rails_helper"

RSpec.describe Buckler do
  subject(:buckler) { Buckler.new(api:)  }

  let(:api) do
    instance_double(Buckler::Api::Client, fighter_banner: instance_double(Buckler::Api::FighterBanner))
  end

  before do
    allow(Parsers::FighterBannerParser).to receive(:parse) { _1[:raw_data] }
    allow(Parsers::BattleParser).to receive(:parse) { _1[:raw_data] }
  end

  describe "#search_fighter_banner" do
    before do
      allow(api.fighter_banner).to receive(:search_fighter_banner).and_return([])
      allow(api.fighter_banner).to receive(:search_fighter_banner).with(term: 'player').and_return([ 1, 2 ])
      allow(api.fighter_banner).to receive(:search_fighter_banner).with(term: '123456789').and_return([ 3, 4 ])
      allow(api.fighter_banner).to receive(:player_fighter_banner).with(short_id: '123456789').and_return(5)
    end

    it { expect(buckler.search_fighter_banner(term: 'player')).to eq [ 1, 2 ] }
    it { expect(buckler.search_fighter_banner(term: '123456789')).to eq [ 3, 4, 5 ] }
    it { expect(buckler.search_fighter_banner(term: 'player_x')).to eq [] }
    it { expect { buckler.search_fighter_banner(term: 'abc') }.to raise_error ArgumentError }
  end

  describe "#fighter_banner" do
    before do
      allow(api.fighter_banner).to receive(:player_fighter_banner).with(short_id: '123456788').and_return(nil)
      allow(api.fighter_banner).to receive(:player_fighter_banner).with(short_id: '123456789').and_return(1)
    end

    it { expect(buckler.fighter_banner(short_id: '123456789')).to eq 1 }
    it { expect { buckler.fighter_banner(short_id: '123456788') }.to raise_error Buckler::PlayerNotFound }
    it { expect { buckler.fighter_banner(short_id: '1234678FOO') }.to raise_error ArgumentError }
  end

  describe "#battle_list" do
    before do
      allow(api).to receive(:replay_list).with(short_id: '123456789').and_return([ 1, 2 ])
    end

    it { expect(buckler.battle_list(short_id: '123456789').to_a).to eq [ 1, 2 ] }
    it { expect { buckler.battle_list(short_id: '12389') }.to raise_error ArgumentError }
  end
end
