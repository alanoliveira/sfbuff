# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlayerSearchJob do
  include ActiveJob::TestHelper

  let(:job) { described_class.perform_later(term) }
  let(:term) { nil }
  let(:api) { instance_double(Buckler::Api) }

  before do
    allow(PlayerSearchChannel).to receive(:broadcast_to)
    allow(BucklerGateway).to receive(:new).and_return(api)
  end

  context 'with term not like a short_id' do
    let(:term) { 'foo bar' }
    let(:search_players_by_name) { create_list(:raw_fighter_banner, 2) }

    before { allow(api).to receive_messages(search_players_by_name:) }

    it 'broadcast a success response with the name search result' do
      job.perform_now
      expect(PlayerSearchChannel).to have_received(:broadcast_to)
        .with(job.job_id, 'success', search_players_by_name)
    end
  end

  context 'with term like a short_id' do
    let(:term) { '123456789' }
    let(:search_players_by_name) { create_list(:raw_fighter_banner, 2) }
    let(:search_player_by_sid) { create(:raw_fighter_banner) }

    before { allow(api).to receive_messages(search_players_by_name:, search_player_by_sid:) }

    it 'broadcast a success response with the name search result + id search result' do
      job.perform_now
      expect(PlayerSearchChannel).to have_received(:broadcast_to)
        .with(job.job_id, 'success', search_players_by_name + [search_player_by_sid])
    end
  end

  context 'when the process throws an error' do
    let(:term) { 'foo bar' }
    let(:error) { StandardError.new('oh no') }

    before { allow(api).to receive(:search_players_by_name).and_raise(error) }

    it 'broadcast a error response with the exception' do
      job.perform_now
    rescue StandardError
      expect(PlayerSearchChannel).to have_received(:broadcast_to).with(job.job_id, 'error', { kind: 'generic' })
    end
  end
end
