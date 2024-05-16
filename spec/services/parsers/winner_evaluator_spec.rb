# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Parsers::WinnerEvaluator do
  describe '.evaluate_winner' do
    subject(:winner) { described_class.evaluate_winner(p1_rounds, p2_rounds) }

    context 'when winner is p1' do
      let(:p1_rounds) { [1, 1] }
      let(:p2_rounds) { [0, 0] }

      it { is_expected.to be 1 }
    end

    context 'when winner is p2' do
      let(:p1_rounds) { [0, 0] }
      let(:p2_rounds) { [1, 1] }

      it { is_expected.to be 2 }
    end

    context 'when it is a true draw' do
      let(:p1_rounds) { [0, 1, 4] }
      let(:p2_rounds) { [1, 0, 4] }

      it { is_expected.to be_nil }
    end

    context 'when the last round is a draw but p1 have more wins' do
      let(:p1_rounds) { [1, 4] }
      let(:p2_rounds) { [0, 4] }

      it { is_expected.to be 1 }
    end
  end
end
