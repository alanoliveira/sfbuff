require 'rails_helper'

RSpec.describe PlayerSearchChannel, type: :channel do
  let(:signed_stream_name) { described_class.signed_stream_name(term) }
  let(:term) { 'foo bar' }

  it 'enqueues a PlayerSearchJob' do
    expect { subscribe signed_stream_name: }.to have_enqueued_job(PlayerSearchJob).with(term)
  end

  context 'when term is empty' do
    let(:term) { '' }

    it 'rejects the stream' do
      subscribe(signed_stream_name:)
      expect(subscription).to be_rejected
    end
  end
end
