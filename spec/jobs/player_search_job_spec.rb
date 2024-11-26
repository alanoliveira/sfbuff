require 'rails_helper'

RSpec.describe PlayerSearchJob, type: :job do
  subject(:job) { described_class.perform_later(term) }

  around(:example) do |ex|
    Rails.with(cache: ActiveSupport::Cache.lookup_store(:memory_store)) do
      ex.run
    end
  end

  let(:buckler_bridge) { instance_double BucklerBridge }
  let(:term) { 'player 1234' }
  let(:response) { [] }

  before do
    allow(BucklerBridge).to receive(:new).and_return(buckler_bridge)
    allow(buckler_bridge).to receive(:search_fighter_banner).with(term:).and_return(response)
  end

  it_behaves_like "a streamable job"
end
