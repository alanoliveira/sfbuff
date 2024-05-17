# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/buckler/player_searches' do
  describe 'POST /create' do
    context 'with valid parameter' do
      it 'schedules a PlayerSearchJob' do
        assert_enqueued_with job: PlayerSearchJob do
          post player_searches_url, params: { term: 'player1' }, as: :turbo_stream
        end
      end

      it 'renders a successful response' do
        post player_searches_url, params: { term: 'player1' }, as: :turbo_stream
        expect(response).to be_successful
      end
    end

    context 'with invalid parameter' do
      it 'not schedules a PlayerSearchJob' do
        assert_no_enqueued_jobs do
          post player_searches_url, params: { term: 'p' }, as: :turbo_stream
        end
      end

      it 'redirects to the root_path' do
        post player_searches_url, params: { term: 'p' }, as: :turbo_stream
        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end

  describe 'GET /show/:id' do
    context 'when the job resonse is cached' do
      before { stub_const('PlayerSearchJob', spy) }

      it 'renders a successful response' do
        get player_search_url('job-id'), as: :turbo_stream
        expect(response).to be_successful
      end
    end

    context 'when the job resonse is not cached' do
      before do
        psj = spy
        stub_const('PlayerSearchJob', psj)
        allow(psj).to receive(:find_job_status!).and_raise(JobCache::NotFound)
      end

      it 'redirects to root_path' do
        get player_search_url('job-id'), as: :turbo_stream
        expect(response).to redirect_to root_path
      end
    end
  end
end
