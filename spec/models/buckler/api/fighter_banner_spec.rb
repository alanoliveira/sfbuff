require 'rails_helper'

RSpec.describe Buckler::Api::FighterBanner do
  subject(:fighter_banner) { described_class.new(client:) }

  let(:client) { instance_double Buckler::Api::Client }

  def mock_request(params, result)
    action_path = "fighterslist/search/result.json"
    allow(client).to receive(:request).with(action_path:, params:).and_return('fighter_banner_list' => result)
  end

  describe '#search_fighter_banner' do
    subject(:result) { fighter_banner.search_fighter_banner(term:) }
    let(:term) { 'Player X' }

    before do
      mock_request({ fighter_id: term }, [ 1, 2, 3 ])
    end

    it "returns the fighter banner list" do
      is_expected.to eq [ 1, 2, 3 ]
    end
  end

  describe '#player_fighter_banner' do
    subject(:result) { fighter_banner.player_fighter_banner(short_id:) }
    let(:short_id) { 12345678 }

    before do
      mock_request({ short_id: }, [ 1 ])
    end

    it "returns the player fighter banner" do
     is_expected.to eq 1
    end

    context "when fighter banner does not exists" do
      before do
        mock_request({ short_id: }, [])
      end

      it { is_expected.to be_nil }
    end
  end
end
