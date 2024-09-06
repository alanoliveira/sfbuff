require "rails_helper"

RSpec.describe FaradayRescueFromErrorMiddleware do
  let(:faraday) do
    Faraday.new do |conf|
      conf.adapter :test, stubs
      conf.use :rescue_from_error, handler: ->(e) { "ok" }
      conf.response :raise_error
    end
  end

  let(:stubs) { Faraday::Adapter::Test::Stubs.new }

  before do
    stubs.get('/400') { [ 400, {}, nil ] }
    stubs.get('/500') { [ 500, {}, nil ] }
  end

  it "rescues from request errors" do
    expect(faraday.get('/400')).to eq "ok"
  end

  it "rescues from server errors" do
    expect(faraday.get('/500')).to eq "ok"
  end
end
