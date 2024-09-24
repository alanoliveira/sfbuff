require "rails_helper"

RSpec.describe BucklerClient, type: :model do
  subject(:buckler_client) { BucklerClient.create(build_id: 1) }

  let(:stubs) { Faraday::Adapter::Test::Stubs.new }

  before do
    allow(Buckler::Api::Connection).to receive(:build).and_wrap_original do |org, args|
      org.call(**args) { |conn| conn.adapter :test, stubs }
    end
  end

  context "when api is under maintenance" do
    before do
      stubs.get(%r{.*/404}) { [ 404, {}, nil ] }
      allow(Buckler::Api::Client).to receive(:under_maintenance?).and_return(true)
    end

    it "raises an error" do
      expect { buckler_client.api.request(action_path: '/404') }
        .to raise_error(BucklerClient::UnderMaintenance)
    end
  end

  context "when api is under maintenance" do
    before do
      stubs.get(%r{.*/503}) { [ 503, {}, nil ] }
    end

    it "raises an error" do
      expect { buckler_client.api.request(action_path: '/503') }
        .to raise_error(BucklerClient::UnderMaintenance)
    end
  end

  context "when api build_id changed" do
    before do
      stubs.get(%r{.*/404}) { [ 404, {}, nil ] }
      allow(Buckler::Api::Client).to receive(:under_maintenance?).and_return(false)
      allow(Buckler::Api::Client).to receive(:remote_build_id).and_return(2)
    end

    it "updates the build_id" do
      expect { buckler_client.api.request(action_path: '/404') }
        .to raise_error(BucklerClient::BuildIdChanged)
        .and change(buckler_client, :build_id).to "2"
    end
  end

  context "when api returns status 403" do
    before { stubs.get(%r{.*/403}) { [ 403, {}, nil ] } }

    it "expires" do
      expect { buckler_client.api.request(action_path: '/403') }
        .to raise_error(Faraday::ForbiddenError)
        .and change(buckler_client, :status).to("expired")
    end
  end

  context "when rate limit exceeds" do
    before do
      stubs.get(%r{.*/405}) { [ 405, { "x-amzn-waf-action": "captcha" }, nil ] }
    end

    it do
      expect { buckler_client.api.request(action_path: '/405') }
        .to raise_error(BucklerClient::RateLimitExceeded)
    end
  end

  describe '#api' do
    context "when credentials are expired" do
      before { buckler_client.expired! }

      it { expect { buckler_client.api }.to raise_error BucklerClient::CredentialExpired }
    end
  end
end
