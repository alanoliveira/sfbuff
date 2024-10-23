require "rails_helper"

RSpec.describe Challenger, type: :model do
  it { expect(Challenger.new(league_point: 0)).to be_rookie }
  it { expect(Challenger.new(league_point: 9000)).to be_gold }
  it { expect(Challenger.new(league_point: 25000)).to be_master }
  it { expect(Challenger.new(league_point: -1)).to be_calibrating }
  it { expect(Challenger.new(league_point: 1)).not_to be_calibrating }
end
