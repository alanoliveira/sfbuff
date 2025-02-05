require 'rails_helper'

RSpec.describe BucklerApi::Client do
  let(:client) { described_class.new(connection) }
  let(:connection) { instance_double(BucklerApi::Connection) }

  def mock_response(data)
    instance_double(BucklerApi::Response, page_props: data)
  end

  describe "#search_fighters" do
    context "when searching by short_id" do
      it "returns the fighter_banner_list" do
        allow(connection).to receive(:get)
          .with("fighterslist/search/result.json", { short_id: 123456789 })
          .and_return(mock_response("fighter_banner_list" => "OK"))

        expect(client.search_fighters(short_id: 123456789)).to eq "OK"
      end
    end

    context "when searching by fighter_id" do
      it "returns the fighter_banner_list" do
        allow(connection).to receive(:get)
          .with("fighterslist/search/result.json", { fighter_id: "fighter" })
          .and_return(mock_response("fighter_banner_list" => "OK"))

        expect(client.search_fighters(fighter_id: "fighter")).to eq "OK"
      end
    end
  end

  describe "#battlelog" do
    it "returns the replay_list of the specified page" do
      allow(connection).to receive(:get)
        .with("profile/123456789/battlelog.json", { page: 5 })
        .and_return(mock_response("replay_list" => "OK"))

      expect(client.fighter_battlelog(123456789, 5)).to eq "OK"
    end
  end
end
