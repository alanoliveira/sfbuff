require "rails_helper"

RSpec.describe BucklerApiGateway do
  let(:buckler_api_gateway) { described_class.new(buckler_api_client) }
  let(:buckler_api_client) { instance_double(BucklerApiClient) }

  describe "#fetch_fighter_replays" do
    let(:fighter_id) { generate(:short_id) }

    def battlelog(total_page)
      (1..100).lazy.map do |current_page|
        {
          "pageProps" => {
            "replay_list" => [ "p#{current_page}" ],
            "current_page" => current_page,
            "total_page" => total_page
          }
        }
      end
    end

    before do
      allow(buckler_api_client).to receive(:battlelog).with(fighter_id).and_return(battlelog(3))
      allow(BucklerApiGateway::Mappers::Replay).to receive(:new) { it }
    end

    it "fetches and maps page battlelogs until reach the last page" do
      expect(buckler_api_gateway.fetch_fighter_replays(fighter_id)).to match([ "p1", "p2", "p3" ])
    end
  end
end
