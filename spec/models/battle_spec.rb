# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Battle do
  describe '#valid?' do
    subject { battle.valid? }

    context 'with an unexpected battle_type' do
      before { stub_const('Buckler::BATTLE_TYPES', Buckler::BATTLE_TYPES.except(2)) }

      let(:battle) { build(:battle, battle_type: 2) }

      it { is_expected.to be_truthy }
    end
  end

  describe '#p1' do
    subject { create(:battle).p1 }

    it { is_expected.to be_a(Challenger).and have_attributes(side: 'p1') }
  end

  describe '#p2' do
    subject { create(:battle).p2 }

    it { is_expected.to be_a(Challenger).and have_attributes(side: 'p2') }
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

  describe '#>' do
    it { expect(create(:battle, played_at: Time.zone.now)).to be > create(:battle, played_at: 1.day.ago) }
  end
end
