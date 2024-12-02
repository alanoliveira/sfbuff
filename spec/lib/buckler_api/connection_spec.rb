require 'rails_helper'

RSpec.describe BucklerApi::Connection do
  let(:connection) { described_class.new(adapter:, build_id:, auth_cookies:) }
  let(:adapter) { spy }
  let(:build_id) { spy(to_s: "build_id") }
  let(:auth_cookies) { spy(to_s: "foo=bar") }

  before do
    stub_const("BucklerApi::BASE_URL", "http://www.example.com")
    stub_const("BucklerApi::USER_AGENT", "test")
  end

  describe "#get" do
    let(:response) do
      instance_double(BucklerApi::Response, status: anything, success?: true, path_not_found?: false, forbidden?: false, under_maintenance?: false, rate_limit_exceeded?: false)
    end

    before { allow(adapter).to receive(:get).and_return(response) }

    it "sends a request with the expected params" do
      allow(response).to receive_messages(success?: true)
      connection.get("foo", bar: 1)
      expect(adapter).to have_received("get")
        .with(URI("http://www.example.com/6/buckler/_next/data/build_id/foo"), params: { bar: 1 }, headers: { "cookie" => "foo=bar", "user-agent" => "test" })
    end

    it "returns the response" do
      expect(connection.get("foo", bar: 1)).to eq response
    end

    context "when response is unsuccessful and forbidden is true" do
      before { allow(response).to receive_messages(success?: false, forbidden?: true) }

      it "raises an HttpError" do
        expect { connection.get("foo") }.to raise_error(BucklerApi::HttpError)
      end

      it "renews the build_id" do
        connection.get("foo") rescue nil
        expect(auth_cookies).to have_received(:renew)
      end
    end

    context "when response is unsuccessful and path_not_found? is true" do
      before { allow(response).to receive_messages(success?: false, path_not_found?: true) }

      it "raises an HttpError" do
        expect { connection.get("foo") }.to raise_error(BucklerApi::HttpError)
      end

      it "renews the build_id" do
        connection.get("foo") rescue nil
        expect(build_id).to have_received(:renew)
      end
    end

    context "when response is unsuccessful and under_maintenance? is true" do
      before { allow(response).to receive_messages(success?: false, under_maintenance?: true) }

      it "raises an UnderMaintenance" do
        expect { connection.get("foo") }.to raise_error(BucklerApi::UnderMaintenance)
      end
    end

    context "when response is unsuccessful and under_maintenance? is true" do
      before { allow(response).to receive_messages(success?: false, rate_limit_exceeded?: true) }

      it "raises an UnderMaintenance" do
        expect { connection.get("foo") }.to raise_error(BucklerApi::RateLimitExceeded)
      end
    end
  end
end
