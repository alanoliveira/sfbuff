require 'rails_helper'

RSpec.describe Buckler::Api::SiteApi do
  subject(:site_api) { described_class.new(connection:) }

  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:connection) do
    Faraday.new do |conf|
      conf.adapter :test, stubs
    end
  end


  describe "#next_data" do
    it "returns the fighter_banner_list" do
      stubs.get("/6/buckler") do
        [ 200, { "content-type" => "text/html" }, "OK" ]
      end
      allow(Buckler::Api::Parser::NextDataParser).to receive(:parse) { "PARSED #{_1}" }

      expect(site_api.next_data).to eq "PARSED OK"
    end
  end
end
