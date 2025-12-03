require "rails_helper"

RSpec.describe BucklerApiClient do
  let(:buckler_api_client) { described_class.new(build_id: "123456", auth_cookie: "secret") }

  before do
    described_class.user_agent = "test-agent"
  end

  it { expect(described_class.user_agent).to eq "test-agent" }

  def stub_request(method, path)
    uri = URI.parse(described_class.base_url).merge("/6/buckler/_next/data/#{buckler_api_client.build_id}/en/#{path}")
    super(method, uri)
      .with(headers: { "Cookie" => buckler_api_client.auth_cookie, "User-Agent" => described_class.user_agent })
  end

  shared_examples "a buckler api dependent method" do
    context "when response code is 403" do
      before { stubbed_request.to_return(status: 403) }

      it { expect { execute }.to raise_error BucklerApiClient::Unauthorized }
    end

    context "when response code is 404 and Content-Type is 'text/html'" do
      before { stubbed_request.to_return(status: 404, headers: { "Content-Type" => "text/html" }) }

      it { expect { execute }.to raise_error BucklerApiClient::PageNotFound }
    end

    context "when response code is 405 and the header 'x-amzn-waf-action' is present" do
      before { stubbed_request.to_return(status: 405, headers: { "x-amzn-waf-action" => "" }) }

      it { expect { execute }.to raise_error BucklerApiClient::RateLimitExceeded }
    end

    context "when response code is 503" do
      before { stubbed_request.to_return(status: 503) }

      it { expect { execute }.to raise_error BucklerApiClient::UnderMaintenance }
    end
  end

  describe "#fighterslist" do
    let(:short_id) { "111222333" }
    let(:fighter_id) { "player" }

    before do
      stub_request(:get, "fighterslist/search/result.json?short_id=#{short_id}")
        .to_return(body: { "data" => "ok" }.to_json, headers: { "Content-Type" => "application/json" })

      stub_request(:get, "fighterslist/search/result.json?fighter_id=#{fighter_id}")
        .to_return(body: { "data" => "ok" }.to_json, headers: { "Content-Type" => "application/json" })
    end

    it_behaves_like "a buckler api dependent method" do
      let(:stubbed_request) { stub_request(:get, "fighterslist/search/result.json?short_id=#{short_id}") }
      let(:execute) { buckler_api_client.fighterslist(short_id:) }
    end

    it { expect(buckler_api_client.fighterslist(short_id:)).to eq("data" => "ok") }
    it { expect(buckler_api_client.fighterslist(fighter_id:)).to eq("data" => "ok") }
  end

  describe "#battlelog" do
    let(:battlelog) { buckler_api_client.battlelog(short_id) }
    let(:short_id) { "111222333" }

    before do
      (1..10).each do |page|
        stub_request(:get, "profile/#{short_id}/battlelog.json")
          .with(query: { page: })
          .to_return(body: { "response" => "pg#{page}" }.to_json, headers: { "Content-Type" => "application/json" })
      end
    end

    it_behaves_like "a buckler api dependent method" do
      let(:stubbed_request) { stub_request(:get, "profile/#{short_id}/battlelog.json?page=1") }
      let(:execute) { buckler_api_client.battlelog(short_id).first }
    end

    it "returns an enumerator returning data for each page" do
      expect(battlelog).to match((1..10).map { { "response" => "pg#{it}" } })
    end
  end

  describe "#play_profile" do
    let(:short_id) { "111222333" }

    before do
      stub_request(:get, "profile/#{short_id}/play.json")
        .to_return(body: { "response" => "ok" }.to_json, headers: { "Content-Type" => "application/json" })
    end

    it_behaves_like "a buckler api dependent method" do
      let(:stubbed_request) { stub_request(:get, "profile/#{short_id}/play.json") }
      let(:execute) { buckler_api_client.play_profile(short_id) }
    end

    it { expect(buckler_api_client.play_profile(short_id)).to eq("response" => "ok") }
  end
end
