# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlayerSearchChannel do
  let(:term) { 'foo bar' }

  it 'enqueues a PlayerSearchJob' do
    expect { subscribe term: }.to have_enqueued_job(PlayerSearchJob).with(term)
  end

  it 'start a stream for the created job' do
    subscribe(term:)
    ActiveJob::Base.queue_adapter.enqueued_jobs.last do |job_info|
      expect(subscription).to have_stream_for(job_info['job_id'])
    end
  end

  context 'when term is empty' do
    let(:term) { '' }

    it 'do not enqueues a PlayerSearchJob' do
      expect { subscribe term: }.not_to have_enqueued_job(PlayerSearchJob).with(term)
    end

    it 'reject the stream' do
      subscribe(term:)
      expect(subscription).to be_rejected
    end
  end
end
