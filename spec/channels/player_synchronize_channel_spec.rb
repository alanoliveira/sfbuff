require 'rails_helper'

RSpec.describe PlayerSynchronizeChannel, type: :channel do
  let(:signed_stream_name) { described_class.signed_stream_name(short_id) }
  let(:short_id) { '123456789' }

  it 'enqueues a PlayerSynchronizeJob' do
    expect { subscribe signed_stream_name: }.to have_enqueued_job(PlayerSynchronizeJob).with(short_id)
  end

  context 'when short_id is empty' do
    let(:short_id) { '' }

    it 'rejects the stream' do
      subscribe(signed_stream_name:)
      expect(subscription).to be_rejected
    end
  end
end