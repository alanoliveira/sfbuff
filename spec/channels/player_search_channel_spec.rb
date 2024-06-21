# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlayerSearchChannel do
  let(:term) { 'foo bar' }
  let(:signed_stream_name) { described_class.signed_stream_name(term) }

  it 'enqueues a PlayerSearchJob' do
    expect { subscribe signed_stream_name: }.to have_enqueued_job(PlayerSearchJob).with(term)
  end

  it 'start a stream for the created job' do
    subscribe(signed_stream_name:)
    ActiveJob::Base.queue_adapter.enqueued_jobs.last do |job_info|
      expect(subscription).to have_stream_for(job_info['job_id'])
    end
  end

  context 'when term is empty' do
    let(:term) { '' }

    it 'do not enqueues a PlayerSearchJob' do
      expect { subscribe signed_stream_name: }.not_to have_enqueued_job(PlayerSearchJob)
    end

    it 'reject the stream' do
      subscribe(signed_stream_name:)
      expect(subscription).to be_rejected
    end
  end
end
