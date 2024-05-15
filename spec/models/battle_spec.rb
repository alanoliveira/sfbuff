# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Battle do
  describe '#challanger' do
    let(:battle) { create(:battle) }

    it 'returns the player 1' do
      expect(battle.p1).to have_attributes(side: 'p1')
    end

    it 'returns the player 2' do
      expect(battle.p2).to have_attributes(side: 'p2')
    end
  end

  describe '#winner' do
    subject(:winner) { battle.winner }

    let(:battle) { create(:battle, winner_side:) }

    context 'when p1 is the winner' do
      let(:winner_side) { 1 }

      it 'returns p1' do
        expect(winner).to be battle.p1
      end
    end

    context 'when p2 is the winner' do
      let(:winner_side) { 2 }

      it 'returns p2' do
        expect(winner).to be battle.p2
      end
    end

    context 'when there is no winner (a draw)' do
      let(:winner_side) { nil }

      it { is_expected.to be_nil }
    end
  end
end
