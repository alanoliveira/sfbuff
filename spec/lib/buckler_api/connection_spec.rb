require 'rails_helper'

RSpec.describe BucklerApi::Connection do
  subject(:connection) do
    described_class.new do |config|
      config.adapter = adapter
      config.base_url = "http://www.example.com"
      config.user_agent = "test"
      config.build_id_manager.strategies << -> { "build_id" }
      config.auth_cookies_manager.strategies << -> { "foo=bar" }
    end
  end

  let(:adapter) { spy }

  describe "#get" do
    let(:response) { BucklerApi::Response.new(status: 200, headers: {}, body: "") }

    before do
      allow(adapter).to receive(:get).and_return(response)
    end

    it "sends the request with the expected params" do
      connection.get("foo", bar: 1)
      expect(adapter).to have_received("get")
        .with(URI("http://www.example.com/6/buckler/_next/data/build_id/en/foo"), params: { bar: 1 }, headers: { "cookie" => "foo=bar", "user-agent" => "test" })
    end

    context "when response is successful" do
      before { allow(response).to receive(:success?).and_return(true) }

      it "returns the response" do
        expect(connection.get("foo", bar: 1)).to eq response
      end
    end

    context "when response is unsuccessful and forbidden is true" do
      before { allow(response).to receive_messages(success?: false, forbidden?: true) }

      it "raises an HttpError" do
        expect { connection.get("foo") }.to raise_error(BucklerApi::Errors::HttpError)
      end
    end

    context "when response is unsuccessful and path_not_found? is true" do
      before { allow(response).to receive_messages(success?: false, path_not_found?: true) }

      it "raises an HttpError" do
        expect { connection.get("foo") }.to raise_error(BucklerApi::Errors::HttpError)
      end
    end

    context "when response is unsuccessful and under_maintenance? is true" do
      before { allow(response).to receive_messages(success?: false, under_maintenance?: true) }

      it "raises an UnderMaintenance" do
        expect { connection.get("foo") }.to raise_error(BucklerApi::Errors::UnderMaintenance)
      end
    end

    context "when response is unsuccessful and rate_limit_exceeded? is true" do
      before { allow(response).to receive_messages(success?: false, rate_limit_exceeded?: true) }

      it "raises an RateLimitExceeded" do
        expect { connection.get("foo") }.to raise_error(BucklerApi::Errors::RateLimitExceeded)
      end
    end
  end
end
