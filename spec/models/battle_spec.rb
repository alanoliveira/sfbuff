# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Battle do
  describe '#challanger' do
    let(:p1) { create(:challanger, side: :p1) }
    let(:p2) { create(:challanger, side: :p2) }
    let(:battle) { create(:battle, :with_challangers, p1:, p2:) }

    it 'returns the player 1' do
      expect(battle.challanger(1)).to eq(p1)
    end

    it 'returns the player 2' do
      expect(battle.challanger(2)).to eq(p2)
    end
  end

  describe '#winner' do
    subject(:winner) { battle.winner }

    let(:p1) { create(:challanger, side: :p1, rounds: p1_rounds) }
    let(:p2) { create(:challanger, side: :p2, rounds: p2_rounds) }
    let(:battle) { create(:battle, :with_challangers, p1:, p2:) }

    context 'when p1 is the winner' do
      let(:p1_rounds) { [1, 1] }
      let(:p2_rounds) { [0, 0] }

      it 'returns p1' do
        expect(winner).to be p1
      end
    end

    context 'when p2 is the winner' do
      let(:p1_rounds) { [0, 0] }
      let(:p2_rounds) { [1, 1] }

      it 'returns p2' do
        expect(winner).to be p2
      end
    end

    context 'when it is a draw' do
      let(:p1_rounds) { [4, 4] }
      let(:p2_rounds) { [4, 4] }

      it { is_expected.to be_nil }
    end
  end
end
