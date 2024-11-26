require 'rails_helper'

RSpec.describe JobChannel, type: :channel do
  let(:signed_stream_name) { described_class.signed_stream_name(job_id) }
  let(:job_id) { '12345' }

  around(:example) do |ex|
    Rails.with(cache: ActiveSupport::Cache.lookup_store(:memory_store)) do
      ex.run
    end
  end

  context "with a cached job_id" do
    before do
      Rails.cache.write("job/#{job_id}", { inline: "OK" })
    end

    it do
      subscribe(signed_stream_name:)
      expect(subscription).to have_stream_for(job_id)
    end

    it { expect { subscribe(signed_stream_name:) }.to have_broadcasted_to(job_id).with(a_string_including("<template>OK</template>")) }
  end

  context "without a cached job" do
    it do
      subscribe(signed_stream_name:)
      expect(subscription).to be_rejected
    end
  end
end
