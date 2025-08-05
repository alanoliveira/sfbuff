require 'rails_helper'

RSpec.describe BucklerApi::Client do
  let(:client) { described_class.new(connection:, auth_cookie:, build_id:) }
  let(:connection) { instance_double(BucklerApi::Connection) }
  let(:auth_cookie) { "ok=1" }
  let(:build_id) { "ABC123" }

  describe "#get" do
    let(:response) { spy }

    before { allow(connection).to receive(:get).and_return(response) }

    it "sends the request with the expected parameters" do
      client.get("foo", { bar: 10 })

      expect(connection).to have_received(:get)
        .with("/6/buckler/_next/data/#{build_id}/en/foo",
          params: { bar: 10 },
          headers: { "Cookie" => auth_cookie })
    end

    context "when response is OK" do
      before { allow(response).to receive_messages(success?: true, body: { "pageProps" => "OK" }) }

      it "returns the pageProps" do
        expect(client.get("foo")).to eq "OK"
      end
    end

    context "when response is NG" do
      before do
        allow(response).to receive_messages(success?: false)
        allow(BucklerApi::Client::ResponseErrorHandler).to receive(:handle!).and_raise("boom")
      end

      it "returns the pageProps" do
        expect { client.get("foo") }.to raise_error("boom")
      end
    end
  end
end
