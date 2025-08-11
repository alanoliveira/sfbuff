require 'rails_helper'

RSpec.describe Fighter::SynchronizeJob do
  let(:sync_job) { described_class.new(fighter) }
  let(:fighter) { create(:fighter) }

  it_behaves_like "a BucklerServerErrorHandleable job" do
    let(:bad_gateway_job) { sync_job }
    before { allow(fighter).to receive(:synchronize_now).and_raise(BucklerApi::Errors::BucklerServerError, spy) }
  end
end
