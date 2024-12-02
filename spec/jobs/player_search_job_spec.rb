require 'rails_helper'

RSpec.describe PlayerSearchJob, type: :job do
  subject(:job) { described_class.perform_later(term) }

  around(:example) do |ex|
    Rails.with(cache: ActiveSupport::Cache.lookup_store(:memory_store)) do
      ex.run
    end
  end

  let(:term) { 'player 1234' }
  let(:response) { [] }

  before do
    allow(FighterBanner).to receive(:search).with(term).and_return(response)
  end

  it_behaves_like "a streamable job"
end
