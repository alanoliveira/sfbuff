require 'rails_helper'

RSpec.describe Buckler::Api::ResponseErrorAnalyzer do
  subject(:analyzer) { described_class.new(response_env) }
  let(:response_env) { spy }

  def headers(...) = Faraday::Utils::Headers.new(...)

  context "when response status is 404 and content-type is not application/json" do
    it do
      allow(response_env).to receive_messages(status: 404, response_headers: headers("content-type" => "text/html"))

      expect(analyzer).to be_path_not_found
    end
  end

  context "when response status is 403" do
    it do
      allow(response_env).to receive_messages(status: 403)

      expect(analyzer).to be_forbidden
    end
  end

  context "when response status is 503" do
    it do
      allow(response_env).to receive_messages(status: 503)

      expect(analyzer).to be_under_maintenance
    end
  end

  context "when response status is 405 with a header 'x-amzn-waf-action'" do
    it do
      allow(response_env).to receive_messages(status: 405, response_headers: headers("x-amzn-waf-action" => anything))

      expect(analyzer).to be_rate_limit_exceeded
    end
  end
end
