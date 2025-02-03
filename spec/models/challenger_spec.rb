require 'rails_helper'

RSpec.describe Challenger, type: :model do
  describe "#opponent" do
    let(:p1) { build(:p1) }
    let(:p2) { build(:p2) }

    before { create(:battle, p1:, p2:) }

    it { expect(p1.opponent).to eq p2 }
    it { expect(p2.opponent).to eq p1 }
  end
end
