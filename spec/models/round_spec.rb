# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Round do
  subject(:round) { described_class.new(raw) }

  context 'when it is a lose' do
    let(:raw) { 0 }

    it { is_expected.to be_lose }
    it { is_expected.not_to be_win }
    it { is_expected.not_to be_draw }
  end

  context 'when it is a win' do
    let(:raw) { 1 }

    it { is_expected.to be_win }
    it { is_expected.not_to be_lose }
    it { is_expected.not_to be_draw }
  end

  context 'when it is a draw' do
    let(:raw) { 4 }

    it { is_expected.to be_draw }
    it { is_expected.not_to be_win }
    it { is_expected.not_to be_lose }
  end
end
