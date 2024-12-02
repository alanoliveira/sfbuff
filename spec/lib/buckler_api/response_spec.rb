require 'rails_helper'

RSpec.describe BucklerApi::Response do
  subject(:response) { described_class.new(status:, headers:, body:) }

  let(:headers) { {} }
  let(:body) { "body" }

  context "when the status is 200" do
    let(:status) { 200 }

    it { is_expected.to be_success }
  end

  context "when the status is 404 with content-type different from json" do
    let(:status) { 404 }
    let(:headers) { { "content-type" => "text/html" } }

    it { is_expected.not_to be_success }
    it { is_expected.to be_path_not_found }
  end

  context "when the status is 403" do
    let(:status) { 403 }

    it { is_expected.not_to be_success }
    it { is_expected.to be_forbidden }
  end

  context "when the status is 503" do
    let(:status) { 503 }

    it { is_expected.not_to be_success }
    it { is_expected.to be_under_maintenance }
  end

  context "when the status is 405 and it have the header 'x-amzn-waf-action'" do
    let(:status) { 405 }
    let(:headers) { { "x-amzn-waf-action" => anything } }

    it { is_expected.not_to be_success }
    it { is_expected.to be_rate_limit_exceeded }
  end
end
