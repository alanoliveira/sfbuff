# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/buckler/player_syncs' do
  describe 'POST /create' do
    context 'when the player is not synchronized' do
      let(:player_sid) { 123_456_789 }

      before do
        player = create(:player, sid: player_sid)
        allow(player).to receive(:synchronized?).and_return(false)
        allow(Player).to receive(:find_by).with(sid: player_sid.to_s).and_return(player)
      end

      it 'schedules a PlayerSyncJob' do
        assert_enqueued_with job: PlayerSyncJob do
          post player_syncs_url, params: { player_sid: }, as: :turbo_stream
        end
      end

      it 'renders a successful response' do
        post player_syncs_url, params: { player_sid: }, as: :turbo_stream
        expect(response).to be_successful
      end
    end

    context 'when the player is already synchronized' do
      let(:player_sid) { 123_456_789 }

      before do
        player = create(:player, sid: player_sid)
        allow(player).to receive(:synchronized?).and_return(true)
        allow(Player).to receive(:find_by).with(sid: player_sid.to_s).and_return(player)
      end

      it 'not schedules a PlayerSyncJob' do
        assert_no_enqueued_jobs do
          post player_syncs_url, params: { player_sid: }, as: :turbo_stream
        end
      end

      it 'renders a successful response' do
        post player_syncs_url, params: { player_sid: }, as: :turbo_stream
        expect(response).to be_successful
      end
    end

    context 'when the player not exists yet' do
      let(:player_sid) { 123_456_789 }

      it 'schedules a PlayerSyncJob' do
        assert_enqueued_with job: PlayerSyncJob do
          post player_syncs_url, params: { player_sid: }, as: :turbo_stream
        end
      end

      it 'renders a successful response' do
        post player_syncs_url, params: { player_sid: }, as: :turbo_stream
        expect(response).to be_successful
      end
    end

    context 'with invalid parameter' do
      it 'not schedules a PlayerSyncJob' do
        assert_no_enqueued_jobs do
          post player_syncs_url, params: { player_sid: 123 }, as: :turbo_stream
        end
      end

      it 'redirects to the root_path' do
        post player_syncs_url, params: { player_sid: 123 }, as: :turbo_stream
        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end

  describe 'GET /show/:id' do
    context 'when the job resonse is cached' do
      before { stub_const('PlayerSyncJob', spy) }

      it 'renders a successful response' do
        get player_sync_url('job-id'), as: :turbo_stream
        expect(response).to be_successful
      end
    end

    context 'when the job resonse is not cached' do
      before do
        psj = spy
        stub_const('PlayerSyncJob', psj)
        allow(psj).to receive(:find_job_status!).and_raise(JobCache::NotFound)
      end

      it 'redirects to root_path' do
        get player_sync_url('job-id'), as: :turbo_stream
        expect(response).to redirect_to root_path
      end
    end
  end
end
