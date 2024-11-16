require 'rails_helper'

RSpec.describe Buckler::Api::Middleware::ResponseErrorHandler do
  let(:handler) { spy.tap { allow(_1).to receive(:call) } }
  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:connection) do
    Faraday.new do |conn|
      conn.adapter :test, stubs
      conn.use described_class, handler:
    end
  end

  context "when the request returns no error" do
    it do
      stubs.get(/.*/) { [ 200, nil, nil ] }
      connection.get("/")
      expect(handler).not_to have_received(:call)
    end
  end

  context "when the request returns an error" do
    it do
      stubs.get(/.*/) { [ 404, nil, nil ] }
      connection.get("/")
      expect(handler).to have_received(:call).with(an_instance_of(Faraday::Env))
    end
  end
end
