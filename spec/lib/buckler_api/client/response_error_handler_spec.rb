require 'rails_helper'

RSpec.describe BucklerApi::Client::ResponseErrorHandler do
  let(:handler) { described_class.new(response) }
  let(:response) { spy }

  def stub_response(body: "", status: 200, headers: {})
    allow(response).to receive_messages(body:, status:, headers:)
  end

  describe "#handle!" do
    context "when response status is 403" do
      before { stub_response(status: 403) }

      it { expect { handler.handle! }.to raise_error(BucklerApi::Errors::Unauthorized) }
    end

    context "when response status is 404 and Content is html" do
      before { stub_response(status: 404, headers: { "Content-Type" => "text/html" }) }

      it { expect { handler.handle! }.to raise_error(BucklerApi::Errors::PageNotFound) }
    end

    context "when response status is 503" do
      before { stub_response(status: 503) }

      it { expect { handler.handle! }.to raise_error(BucklerApi::Errors::UnderMaintenance) }
    end

    context "when response status is 405" do
      before { stub_response(status: 405, headers: { "x-amzn-waf-action" => "" }) }

      it { expect { handler.handle! }.to raise_error(BucklerApi::Errors::RateLimitExceeded) }
    end

    context "when response does not have a specific handling rule" do
      before { stub_response(status: 999) }

      it { expect { handler.handle! }.to raise_error(BucklerApi::Errors::HttpError) }
    end
  end
end
