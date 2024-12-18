require "rails_helper"

RSpec.describe PlayerSearchJob, type: :job do
  subject(:job) { described_class.perform_later(query) }

  around(:example) do |ex|
    Rails.with(cache: ActiveSupport::Cache.lookup_store(:memory_store)) do
      ex.run
    end
  end

  let(:query) { "player 1234" }
  let(:response) { [] }

  before do
    allow(FighterBanner).to receive(:search).with(query).and_return(response)
  end

  it_behaves_like "a streamable job"

  context "when the query parameter is not normalized" do
    let(:query) { "  NoT NoRmAlIZed  " }

    it "normalizes the query before search" do
      allow(FighterBanner).to receive(:search)

      job.perform_now
      expect(FighterBanner).to have_received(:search).with("not normalized")
    end
  end
end
