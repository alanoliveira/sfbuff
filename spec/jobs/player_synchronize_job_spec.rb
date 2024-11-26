require 'rails_helper'

RSpec.describe PlayerSynchronizeJob, type: :job do
  subject(:job) { described_class.perform_later(short_id) }

  around(:example) do |ex|
    Rails.with(cache: ActiveSupport::Cache.lookup_store(:memory_store)) do
      ex.run
    end
  end

  let(:synchronizer) { instance_double Synchronizer }
  let(:short_id) { '123456789' }

  before do
    allow(Synchronizer).to receive(:new).with(short_id:).and_return(synchronizer)
    allow(synchronizer).to receive(:synchronize!)
  end

  it_behaves_like "a streamable job"

  it "synchronizes the player" do
    job.perform_now
    expect(synchronizer).to have_received(:synchronize!)
  end
end
