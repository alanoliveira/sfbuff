# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlayerSyncChannel do
  let(:player_sid) { generate(:player_sid) }
  let(:signed_stream_name) { described_class.signed_stream_name(player_sid) }

  it 'enqueues a PlayerSyncJob' do
    expect { subscribe signed_stream_name: }.to have_enqueued_job(PlayerSyncJob).with(player_sid.to_s)
  end

  it 'start a stream for the created job' do
    subscribe(signed_stream_name:)
    ActiveJob::Base.queue_adapter.enqueued_jobs.last do |job_info|
      expect(subscription).to have_stream_for(job_info['job_id'])
    end
  end

  context 'when player_sid is not valid' do
    let(:player_sid) { '123' }

    it 'do not enqueues a PlayerSyncJob' do
      expect { subscribe }.not_to have_enqueued_job(PlayerSyncJob).with(player_sid)
    end

    it 'reject the stream' do
      subscribe
      expect(subscription).to be_rejected
    end
  end
end
