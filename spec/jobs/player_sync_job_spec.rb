# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlayerSyncJob do
  include ActiveJob::TestHelper

  let(:job) { described_class.perform_later(player_sid) }
  let(:player_sid) { 123_456_789 }
  let(:synchronizer) { instance_double(PlayerSynchronizer, synchronize: nil) }

  before do
    allow(PlayerSynchronizer).to receive(:new)
      .with(player_sid, anything).and_return(synchronizer)
    class_spy(JobCache).as_stubbed_const
    class_spy(BucklerGateway).as_stubbed_const
  end

  it_behaves_like 'a cacheable job'

  context 'when player not exists yet' do
    before do
      allow(Player).to receive(:find_by).with(sid: player_sid).and_return(nil)
    end

    it 'update the cache status' do
      perform_enqueued_jobs { job }
      expect(JobCache).to have_received(:save).with(job.job_id, :success, nil)
    end

    it 'synchronize the player' do
      perform_enqueued_jobs { job }
      expect(synchronizer).to have_received(:synchronize)
    end
  end

  context 'when player exists but is not synchronized' do
    before do
      allow(Player).to receive(:find_by).with(sid: player_sid).and_return(
        instance_double(Player, synchronized?: false)
      )
    end

    it 'update the cache status' do
      perform_enqueued_jobs { job }
      expect(JobCache).to have_received(:save).with(job.job_id, :success, nil)
    end

    it 'synchronize the player' do
      perform_enqueued_jobs { job }
      expect(synchronizer).to have_received(:synchronize)
    end
  end

  context 'when player exists and already is synchronized' do
    before do
      allow(Player).to receive(:find_by).with(sid: player_sid).and_return(
        instance_double(Player, synchronized?: true)
      )
    end

    it 'update the cache status' do
      perform_enqueued_jobs { job }
      expect(JobCache).to have_received(:save).with(job.job_id, :success, nil)
    end

    it 'do not synchronize the player' do
      perform_enqueued_jobs { job }
      expect(synchronizer).not_to have_received(:synchronize)
    end
  end
end
