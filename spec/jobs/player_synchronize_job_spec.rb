require 'rails_helper'

RSpec.describe PlayerSynchronizeJob, type: :job do
  subject(:job) { described_class.perform_later(short_id) }

  let(:synchronizer) { instance_double Synchronizer }
  let(:short_id) { '123456789' }

  before do
    allow(Synchronizer).to receive(:new).with(short_id:).and_return(synchronizer)
    allow(synchronizer).to receive(:synchronize!)
    allow(PlayerSynchronizeChannel).to receive(:broadcast_response)
    allow(PlayerSynchronizeChannel).to receive(:broadcast_error)
  end

  it 'broadcasts the success response' do
    job.perform_now
    expect(PlayerSynchronizeChannel).to have_received(:broadcast_response).with(to: job.job_id)
  end

  context 'when the execution fails' do
    let(:error) { RuntimeError.new("boom") }

    before { allow(synchronizer).to receive(:synchronize!).and_raise(error) }

    it 'broadcasts the error response' do
      expect { job.perform_now }.to raise_error(error) do
        expect(PlayerSynchronizeChannel).to have_received(:broadcast_error).with(to: job.job_id, error:)
      end
    end
  end
end
