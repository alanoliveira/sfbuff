require "rails_helper"

RSpec.describe Buckler::BattlelogIterator do
  subject(:replays) { described_class.new(next_api:, short_id:) }

  let(:next_api) { instance_double Buckler::Api::NextApi }
  let(:short_id) { "12345678" }

  def mock_request(page, result)
    allow(next_api).to receive(:battlelog).with(short_id, page).and_return(result)
  end

  context "when player have replays" do
    it "returns an iterator with the replays" do
      mock_request(anything, [])
      mock_request(1, [ 1, 2 ])
      mock_request(2, [ 3, 4 ])

      expect(replays.to_a).to eq [ 1, 2, 3, 4 ]
    end
  end

  context "when player have no replays" do
    it "returns an empty iterator" do
      mock_request(anything, [])

      expect(replays.to_a).to eq []
    end
  end

  context "a complete iteration" do
    it "stops without fetch page 11" do
      (1..11).each { |p| mock_request(p, [ p ]) }

      expect(replays.to_a).to eq (1..10).to_a
    end
  end
end
