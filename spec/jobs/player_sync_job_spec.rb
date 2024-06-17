# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlayerSyncJob do
  include ActiveJob::TestHelper

  let(:job) { described_class.perform_later(player_sid) }
  let(:player_sid) { generate(:player_sid) }
  let(:synchronizer) { instance_double(PlayerSynchronizer, call: nil) }

  before do
    allow(BucklerGateway).to receive(:new).and_return(spy)
    allow(PlayerSyncChannel).to receive(:broadcast_to)
    allow(PlayerSynchronizer).to receive(:new)
      .with(player_sid:, api: anything).and_return(synchronizer)
  end

  context 'when player is already synchronized' do
    before do
      allow(Player).to receive(:find_by).with(sid: player_sid).and_return(
        instance_double(Player, synchronized?: true)
      )
    end

    it 'do not synchronize the player' do
      perform_enqueued_jobs { job }
      expect(synchronizer).not_to have_received(:call)
    end

    it 'broadcast a success response' do
      job.perform_now
      expect(PlayerSyncChannel).to have_received(:broadcast_to)
        .with(job.job_id, 'success', nil)
    end
  end

  context 'when player is not synchronized' do
    before do
      allow(Player).to receive(:find_by).with(sid: player_sid).and_return(
        instance_double(Player, synchronized?: false)
      )
    end

    it 'synchronize the player' do
      perform_enqueued_jobs { job }
      expect(synchronizer).to have_received(:call)
    end

    it 'broadcast a success response' do
      job.perform_now
      expect(PlayerSyncChannel).to have_received(:broadcast_to)
        .with(job.job_id, 'success', nil)
    end
  end

  context 'when player not exists' do
    before do
      allow(Player).to receive(:find_by).with(sid: player_sid).and_return(nil)
    end

    it 'synchronize the player' do
      perform_enqueued_jobs { job }
      expect(synchronizer).to have_received(:call)
    end

    it 'broadcast a success response' do
      job.perform_now
      expect(PlayerSyncChannel).to have_received(:broadcast_to)
        .with(job.job_id, 'success', nil)
    end
  end

  context 'when the process throws an error' do
    let(:error) { StandardError.new('oh no') }

    before { allow(synchronizer).to receive(:call).and_raise(error) }

    it 'broadcast a error response with the exception' do
      job.perform_now
    rescue StandardError
      expect(PlayerSyncChannel).to have_received(:broadcast_to).with(job.job_id, 'error', error)
    end
  end
end
