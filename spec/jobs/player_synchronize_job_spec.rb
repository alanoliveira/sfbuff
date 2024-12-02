require 'rails_helper'

RSpec.describe PlayerSynchronizeJob, type: :job do
  subject(:job) { described_class.perform_later(short_id) }

  around(:example) do |ex|
    Rails.with(cache: ActiveSupport::Cache.lookup_store(:memory_store)) do
      ex.run
    end
  end

  let(:short_id) { 123456789 }

  before do
    allow(PlayerSynchronizer).to receive(:run)
  end

  it_behaves_like "a streamable job"

  it "synchronizes the player" do
    job.perform_now
    expect(PlayerSynchronizer).to have_received(:run).with(player: an_object_having_attributes(short_id:))
  end
end
