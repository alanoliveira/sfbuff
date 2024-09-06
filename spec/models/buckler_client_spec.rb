require "rails_helper"

RSpec.describe BucklerClient, type: :model do
  subject(:buckler_client) { BucklerClient.create }

  let(:stubs) { Faraday::Adapter::Test::Stubs.new }

  before do
    allow(Buckler::Api::Connection).to receive(:build).and_wrap_original do |org, args|
      org.call(**args) { |conn| conn.adapter :test, stubs }
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

  describe '#api' do
    context "when credentials are expired" do
      before { buckler_client.expired! }

      it { expect { buckler_client.api }.to raise_error BucklerClient::CredentialExpired }
    end
  end
end
