# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlayerSearchJob do
  include ActiveJob::TestHelper

  let(:job) { described_class.perform_later('player') }
  let(:data) { [1, 2, 3, 4] }

  before do
    class_spy(JobCache).as_stubbed_const
    buckler_gw = spy(search_players_by_name: data) # rubocop:disable RSPec/VerifiedDoubles
    allow(BucklerGateway).to receive(:new).and_return(buckler_gw)
  end

  it_behaves_like 'a cacheable job'

  it 'cache a success data with the buckler return' do
    perform_enqueued_jobs { job }
    expect(JobCache).to have_received(:save).with(job.job_id, :success, data)
  end
end
