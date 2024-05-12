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

    let(:p1) { { rounds: p1_rounds } }
    let(:p2) { { rounds: p2_rounds } }
    let(:battle) { create(:battle, p1:, p2:) }

    context 'when p1 is the winner' do
      let(:p1_rounds) { [1, 1] }
      let(:p2_rounds) { [0, 0] }

      it 'returns p1' do
        expect(winner).to be battle.p1
      end
    end

    context 'when p2 is the winner' do
      let(:p1_rounds) { [0, 0] }
      let(:p2_rounds) { [1, 1] }

      it 'returns p2' do
        expect(winner).to be battle.p2
      end
    end

    context 'when it is a draw' do
      let(:p1_rounds) { [4, 4] }
      let(:p2_rounds) { [4, 4] }

      it { is_expected.to be_nil }
    end
  end
end
