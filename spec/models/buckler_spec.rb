require "rails_helper"

RSpec.describe Buckler do
  subject(:buckler) { Buckler.new(api:)  }
  let(:api) { instance_double Buckler::Api::Client }

  describe "#search_fighter_banner" do
    let(:fighter_banner) { instance_double Buckler::Api::FighterBanner }

    before do
      allow(api).to receive(:fighter_banner).and_return(fighter_banner)
      allow(fighter_banner).to receive(:search_fighter_banner).and_return([])
      allow(fighter_banner).to receive(:search_fighter_banner).with(term: 'player').and_return([ 1, 2 ])
      allow(fighter_banner).to receive(:search_fighter_banner).with(term: '123456789').and_return([ 3, 4 ])
      allow(fighter_banner).to receive(:player_fighter_banner).with(short_id: '123456789').and_return(5)
      allow(Parsers::FighterBannerParser).to receive(:parse) { _1[:raw_data] }
    end

    it { expect(buckler.search_fighter_banner(term: 'player')).to eq [ 1, 2 ] }
    it { expect(buckler.search_fighter_banner(term: '123456789')).to eq [ 3, 4, 5 ] }
    it { expect(buckler.search_fighter_banner(term: 'player_x')).to eq [] }
    it { expect { buckler.search_fighter_banner(term: 'abc') }.to raise_error ArgumentError }
  end
end
