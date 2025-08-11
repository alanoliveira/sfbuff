require 'rails_helper'

RSpec.describe FighterSearchProcess::SearchJob do
  let(:search_job) { described_class.new(fighter_search) }
  let(:fighter_search) { FighterSearchProcess.create(query: "SuperPlayer") }

  it_behaves_like "a BadGatewayHandleable job" do
    let(:bad_gateway_job) { search_job }
    before { allow(fighter_search).to receive(:search_now!).and_raise(BucklerApi::Errors::BadGateway, spy) }
  end
end
