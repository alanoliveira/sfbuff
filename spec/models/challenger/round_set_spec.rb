require 'rails_helper'

RSpec.describe Challenger::RoundSet, type: :model do
  describe "#result" do
    subject(:result) { described_class.new(round_ids).result }

    context "when the sum of rounds results is positive" do
      let(:round_ids) { [ 1, 0, 1 ] }

      it { is_expected.to eq Result::WIN }
    end

    context "when the sum of rounds results is negative" do
      let(:round_ids) { [ 1, 0, 0 ] }

      it { is_expected.to eq Result::LOSE }
    end

    context "when the sum of rounds results is zero" do
      let(:round_ids) { [ 1, 0, 4 ] }

      it { is_expected.to eq Result::DRAW }
    end
  end
end
