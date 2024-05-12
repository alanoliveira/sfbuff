# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Player do
  describe '#synchronized?' do
    subject { player.synchronized? }

    let(:threshold) { 10.minutes }

    around do |ex|
      Rails.configuration.sfbuff.with(data_sync_threshold: threshold) do
        ex.run
      end
    end

    context 'when the player is synchronized' do
      let(:player) { create(:player, synchronized_at: (threshold - 1.minute).ago) }

      it { is_expected.to be_truthy }
    end

    context 'when the player not is synchronized' do
      let(:player) { create(:player, synchronized_at: (threshold + 1.minute).ago) }

      it { is_expected.to be_falsey }
    end
  end

  describe '#battles' do
    subject(:player_battles) { player.battles }

    let(:player) { create(:player) }

    before do
      create_list(:battle, 3, p1: { player_sid: player.sid })
      create_list(:battle, 4, p2: { player_sid: player.sid })
      create_list(:battle, 5)
    end

    it 'return player battles' do
      expect(player_battles).to have_attributes(count: 7)
    end
  end
end
