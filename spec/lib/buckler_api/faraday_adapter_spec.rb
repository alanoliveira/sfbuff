require 'rails_helper'

RSpec.describe BucklerApi::FaradayAdapter do
  let(:stubs) { Faraday::Adapter::Test::Stubs.new }

  before do
    Faraday.default_connection = Faraday::Connection.new do |conn|
      conn.adapter :test, stubs
    end
  end

  describe ".get" do
    before { stubs.get("http://www.example.com/foo?bar=1", baz: 2) { [ 200, { "content-type" => "application/json" }, '{"message": "ok"}' ] } }

    it "sends a get request to the specified url, with the specified params and headers" do
      described_class.get("http://www.example.com/foo", params: { bar: 1 }, headers: { baz: 2 })
    end

    it "creates a response" do
      expect(described_class.get("http://www.example.com/foo", params: { bar: 1 }, headers: { baz: 2 }))
        .to be_an_instance_of(BucklerApi::Response).and \
          have_attributes(status: 200, headers: { "content-type" => "application/json" }, body: '{"message": "ok"}')
    end
  end
end
