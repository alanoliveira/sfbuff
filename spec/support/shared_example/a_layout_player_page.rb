# frozen_string_literal: true

RSpec.shared_examples 'a layout/players page' do
  context 'when player exists and is synchronized' do
    let(:player) { create(:player, :synchronized) }

    it do
      expect(response.body).not_to have_stream_source('PlayerSyncChannel') if response.successful?
    end
  end

  context 'when player exists but not synchronized' do
    let(:player) { create(:player, :desynchronized) }

    it do
      expect(response.body).to have_stream_source('PlayerSyncChannel') if response.successful?
    end
  end

  context 'when player do not exists' do
    let(:player) { build(:player) }

    it do
      expect(response.body).to have_stream_source('PlayerSyncChannel') if response.successful?
    end
  end
end
