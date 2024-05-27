# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlayerSearchJob do
  include ActiveJob::TestHelper

  let(:job) { described_class.perform_later(term) }
  let(:name_result) { [1, 2, 3, 4] }
  let(:sid_result) { 5 }
  let(:term) { 'player' }

  before do
    class_spy(JobCache).as_stubbed_const
    buckler_gw = spy(search_players_by_name: name_result.dup, search_player_by_sid: sid_result.dup) # rubocop:disable RSpec/VerifiedDoubles
    allow(BucklerGateway).to receive(:new).and_return(buckler_gw)
  end

  it_behaves_like 'a cacheable job'

  it 'cache a success data with the buckler return' do
    perform_enqueued_jobs { job }
    expect(JobCache).to have_received(:save).with(job.job_id, :success, name_result)
  end

  context 'when the search term is like a short id and the short_id player is found' do
    let(:term) { '123456789' }

    it 'cache a success data with the name searching result + short_id result' do
      perform_enqueued_jobs { job }
      expect(JobCache).to have_received(:save).with(job.job_id, :success, name_result + [sid_result])
    end
  end

  context 'when the search term is like a short id and the short_id player is not found' do
    let(:term) { '123456789' }
    let(:sid_result) { nil }

    it 'cache a success data with the name searching result and ignores the short_id result' do
      perform_enqueued_jobs { job }
      expect(JobCache).to have_received(:save).with(job.job_id, :success, name_result)
    end
  end
end
