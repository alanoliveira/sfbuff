require 'rails_helper'

RSpec.describe Buckler::Middleware::NextApiErrorHandler do
  let(:client) { spy }
  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:connection) do
    Faraday.new do |conn|
      conn.adapter :test, stubs
      conn.use described_class, client:
    end
  end

  context "when request returts status 404 and content-type is not application/json" do
    it "resets client next_data and raises HttpError" do
      allow(client).to receive(:reset_build_id!)
      stubs.get(/.*/) { [ 404, { "content-type" => "text/html" }, nil ] }

      expect { connection.get("/") }.to raise_error Buckler::HttpError do
        expect(client).to have_received(:reset_build_id!)
      end
    end
  end

  context "when request returts status 404 and content-type is application/json" do
    it "raises HttpError without reset next_data" do
      allow(client).to receive(:reset_build_id!)
      stubs.get(/.*/) { [ 404, { "content-type" => "application/json" }, nil ] }

      expect { connection.get("/") }.to raise_error Buckler::HttpError do
        expect(client).not_to have_received(:reset_build_id!)
      end
    end
  end

  context "when request returts status 403" do
    it "resets client authentication and raises HttpError" do
      allow(client).to receive(:reset_authentication!)
      stubs.get(/.*/) { [ 403, nil, nil ] }

      expect { connection.get("/") }.to raise_error Buckler::HttpError do
        expect(client).to have_received(:reset_authentication!)
      end
    end
  end

  context "when request returts status 503" do
    it "raises UnderMaintenance" do
      stubs.get(/.*/) { [ 503, nil, nil ] }

      expect { connection.get("/") }.to raise_error Buckler::UnderMaintenance
    end
  end

  context "when request returts status 405 with a header 'x-amzn-waf-action'" do
    it "raises RateLimitExceeded" do
      stubs.get(/.*/) { [ 405, { "x-amzn-waf-action" => anything }, nil ] }

      expect { connection.get("/") }.to raise_error Buckler::RateLimitExceeded
    end
  end
end
