require 'rails_helper'

RSpec.describe Buckler::Api::Replays do
  subject(:replays) { described_class.new(client:, short_id:) }

  let(:client) { instance_double Buckler::Api::Client }
  let(:short_id) { '12345678' }

  def mock_request(page, result)
    action_path = "profile/#{short_id}/battlelog.json"
    allow(client).to receive(:request).with(action_path:, params: { page: }).and_return('replay_list' => result)
  end

  context 'when player have replays' do
    before do
      mock_request(anything, [])
      mock_request(1, [ 1, 2 ])
      mock_request(2, [ 3, 4 ])
    end

    it "returns an iterator with the replays" do
      expect(replays.to_a).to eq [ 1, 2, 3, 4 ]
    end
  end

  context 'when player have no replays' do
    before do
      mock_request(anything, [])
    end

    it "returns an empty iterator" do
      expect(replays.to_a).to eq []
    end
  end

  context 'when the iterator reach the page 10' do
    before do
      (1..11).each { |p| mock_request(p, [ p ]) }
    end

    it "stops without fetch page 11" do
      expect(replays.to_a).to eq (1..10).to_a
    end
  end
end
