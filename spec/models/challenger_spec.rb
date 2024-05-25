# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Challenger do
  describe '#valid?' do
    subject { challenger.valid? }

    context 'with an unexpected character' do
      before { stub_const('Buckler::CHARACTERS', Buckler::CHARACTERS.except(2)) }

      let(:challenger) { build(:challenger, battle: create(:battle), character: 2) }

      it { is_expected.to be_truthy }
    end

    context 'with an unexpected control type' do
      before { stub_const('Buckler::CONTROL_TYPES', Buckler::CONTROL_TYPES.except(2)) }

      let(:challenger) { build(:challenger, battle: create(:battle), control_type: 2) }

      it { is_expected.to be_truthy }
    end
  end
end
