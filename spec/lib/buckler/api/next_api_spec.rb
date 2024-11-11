require 'rails_helper'

RSpec.describe Buckler::Api::NextApi do
  subject(:next_api) { described_class.new(connection:) }

  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:connection) do
    Faraday.new do |conf|
      conf.adapter :test, stubs
    end
  end

  describe "#fighterslist" do
    context "when searching by short_id" do
      it "returns the fighter_banner_list" do
        stubs.get("/fighterslist/search/result.json?short_id=123456789") do
          [ 200, { "content-type" => "application/json" }, { pageProps: { fighter_banner_list: "OK" } }.to_json ]
        end

        expect(next_api.fighterslist(short_id: "123456789")).to eq "OK"
      end
    end

    context "when searching by fighter_id" do
      it "returns the fighter_banner_list" do
        stubs.get("/fighterslist/search/result.json?fighter_id=123456789") do
          [ 200, { "content-type" => "application/json" }, { pageProps: { fighter_banner_list: "OK" } }.to_json ]
        end

        expect(next_api.fighterslist(fighter_id: "123456789")).to eq "OK"
      end
    end
  end

  describe "#battlelog" do
    it "returns the replay_list of the specified page" do
      stubs.get("profile/123456789/battlelog.json") do |env|
        [ 200, { "content-type" => "application/json" }, { pageProps: { replay_list: "pg#{env.params["page"]}" } }.to_json ]
      end

      expect(next_api.battlelog("123456789", 2)).to eq "pg2"
    end
  end
end
