require "rails_helper"

RSpec.describe Player, type: :model do
  before do
    described_class.synchronized_threshold = 10.minutes
  end

  it { expect(Player.new(synchronized_at: 9.minutes.ago)).to be_synchronized }
  it { expect(Player.new(synchronized_at: 11.minutes.ago)).not_to be_synchronized }
  it { expect(Player.new(synchronized_at: nil)).not_to be_synchronized }
end
