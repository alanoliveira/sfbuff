# frozen_string_literal: true

RSpec.shared_examples 'a cacheable job' do
  include ActiveJob::TestHelper

  it 'cache status :waiting when enqueued' do
    expect(JobCache).to have_received(:save).with(job.job_id, :waiting, nil)
  end

  context 'when the job execution throws an error' do
    before do
      allow(job).to receive(:perform).and_raise(StandardError, 'message')
    end

    # rubocop:disable RSpec/MultipleExpectations
    it 'cache status :error with error data' do
      expect { job.perform_now }.to raise_error do |err|
        expect(JobCache).to have_received(:save)
          .with(job.job_id, :error, { class: err.class.to_s, message: err.message })
      end
    end
    # rubocop:enable RSpec/MultipleExpectations
  end
end
