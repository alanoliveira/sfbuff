# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlayerSyncChannel do
  let(:player_sid) { generate(:player_sid) }

  it 'enqueues a PlayerSyncJob' do
    expect { subscribe player_sid: }.to have_enqueued_job(PlayerSyncJob).with(player_sid)
  end

  it 'start a stream for the created job' do
    subscribe(player_sid:)
    ActiveJob::Base.queue_adapter.enqueued_jobs.last do |job_info|
      expect(subscription).to have_stream_for(job_info['job_id'])
    end
  end

  context 'when player_sid is not valid' do
    let(:player_sid) { '123' }

    it 'do not enqueues a PlayerSyncJob' do
      expect { subscribe player_sid: }.not_to have_enqueued_job(PlayerSyncJob).with(player_sid)
    end

    it 'reject the stream' do
      subscribe(player_sid:)
      expect(subscription).to be_rejected
    end
  end
end
