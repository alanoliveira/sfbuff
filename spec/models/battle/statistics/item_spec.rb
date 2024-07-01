# frozen_string_literal: true

require 'rails_helper'

describe Battle::Statistics::Item do
  let(:item) { described_class.new(wins: 3, loses: 2, draws: 1) }

  describe '#diff' do
    subject(:diff) { item.diff }

    it { is_expected.to eq 1 }

    context 'with uninitialized fields' do
      let(:item) { described_class.new(wins: nil, loses: nil, draws: nil) }

      it { is_expected.to be_nil }
    end
  end

  describe '#total' do
    subject(:total) { item.total }

    it { is_expected.to eq 6 }

    context 'with uninitialized fields' do
      let(:item) { described_class.new(wins: nil, loses: nil, draws: nil) }

      it { is_expected.to be_nil }
    end
  end
end
