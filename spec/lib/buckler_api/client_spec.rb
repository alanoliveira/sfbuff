require 'rails_helper'

RSpec.describe BucklerApi::Client do
  let(:client) { described_class.new(connection, locale) }
  let(:connection) { instance_double(BucklerApi::Connection) }
  let(:locale) { "ja" }

  describe "#fighterslist" do
    context "when searching by short_id" do
      it "returns the fighter_banner_list" do
        allow(connection).to receive(:get)
          .with("#{locale}/fighterslist/search/result.json", { short_id: 123456789 })
          .and_return(spy(page_props: { "fighter_banner_list" => "OK" }))

        expect(client.fighterslist(short_id: 123456789)).to eq "OK"
      end
    end

    context "when searching by fighter_id" do
      it "returns the fighter_banner_list" do
        allow(connection).to receive(:get)
          .with("#{locale}/fighterslist/search/result.json", { fighter_id: "fighter" })
          .and_return(spy(page_props: { "fighter_banner_list" => "OK" }))

        expect(client.fighterslist(fighter_id: "fighter")).to eq "OK"
      end
    end
  end

  describe "#battlelog" do
    it "returns the replay_list of the specified page" do
      allow(connection).to receive(:get)
        .with("#{locale}/profile/123456789/battlelog.json", { page: 5 })
        .and_return(spy(page_props: { "replay_list" => "OK" }))

      expect(client.battlelog(123456789, 5)).to eq "OK"
    end
  end
end
