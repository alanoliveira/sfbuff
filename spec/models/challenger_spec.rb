require 'rails_helper'

RSpec.describe Challenger, type: :model do
  describe "before_save" do
    it "set played_at" do
      freeze_time
      challenger = build(:p1, battle: build(:battle, played_at: Time.now, p2: build(:p2)))
      expect(challenger.played_at).to be_nil
      expect { challenger.save }.to change { challenger.played_at }.from(nil).to(Time.now)
    end
  end

  describe "#opponent" do
    let(:p1) { build(:p1) }
    let(:p2) { build(:p2) }

    before { create(:battle, p1:, p2:) }

    it { expect(p1.opponent).to eq p2 }
    it { expect(p2.opponent).to eq p1 }
  end
end
