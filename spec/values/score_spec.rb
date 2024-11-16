require "rails_helper"

RSpec.describe Score do
  subject(:score) { described_class.new(win: 3, lose: 2, draw: 1, total: 6, diff: 1) }

  it { expect(score.win_percent).to be_within(0.1).of(50) }
  it { expect(score.lose_percent).to be_within(0.1).of(33.33) }
  it { expect(score.draw_percent).to be_within(0.1).of(16.66) }

  describe "#+" do
    it do
      other = described_class.new(win: 1, lose: 2, draw: 3, total: 6, diff: -1)
      expect(score + other).to have_attributes(win: 4, lose: 4, draw: 4, total: 12, diff: 0)
    end
  end
end
