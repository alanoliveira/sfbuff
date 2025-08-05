require 'rails_helper'

RSpec.describe BucklerApi::Connection do
  let(:connection) { described_class.new(base_url:, user_agent:) { |cfg| cfg.adapter :test, stubs } }
  let(:base_url) { "http://www.example.com" }
  let(:user_agent) { "test" }
  let(:stubs) { Faraday::Adapter::Test::Stubs.new(strict_mode: true) }

  describe "#get" do
    context "without parameters or headers" do
      before { stubs.get("/foo", { "User-Agent" => "test" }) { |env| [ 200, {}, "" ] } }

      it { expect(connection.get("foo")).to be_success }
    end

    context "with parameters" do
      before { stubs.get("/foo?id=1", { "User-Agent" => "test" }) { |env| [ 200, {}, "" ] } }

      it { expect(connection.get("foo", params: { id: 1 })).to be_success }
    end

    context "with headers" do
      before { stubs.get("/foo", { "User-Agent" => "test", "Cookie" => "ok" }) { |env| [ 200, {}, "" ] } }

      it { expect(connection.get("foo", headers: { "Cookie": "ok" })).to be_success }
    end

    context "when the response is a json" do
      before { stubs.get("/", { "User-Agent" => "test" }) { |env| [ 200, { "Content-Type" => "application/json" }, '{"foo": 1}' ] } }

      it { expect(connection.get("/")).to be_success }

      it "transform the body into a Hash" do
        expect(connection.get("/").body).to eq({ "foo" => 1 })
      end
    end
  end
end
