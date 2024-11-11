require 'rails_helper'

RSpec.describe PlayerSearchJob, type: :job do
  subject(:job) { described_class.perform_later(term) }

  let(:buckler_bridge) { instance_double BucklerBridge }
  let(:term) { 'player 1234' }
  let(:response) { [] }

  before do
    allow(BucklerBridge).to receive(:new).and_return(buckler_bridge)
    allow(buckler_bridge).to receive(:search_fighter_banner).with(term:).and_return(response)
    allow(PlayerSearchChannel).to receive(:broadcast_response)
    allow(PlayerSearchChannel).to receive(:broadcast_error)
  end

  it 'broadcasts the success response' do
    job.perform_now
    expect(PlayerSearchChannel).to have_received(:broadcast_response).with(to: job.job_id, data: response)
  end

  context 'when the execution fails' do
    let(:error) { RuntimeError.new("boom") }

    before { allow(buckler_bridge).to receive(:search_fighter_banner).with(term:).and_raise(error) }

    it 'broadcasts the error response' do
      expect { job.perform_now }.to raise_error(error) do
        expect(PlayerSearchChannel).to have_received(:broadcast_error).with(to: job.job_id, error:)
      end
    end
  end
end
