require "rails_helper"

RSpec.describe Buckler::LeaguePoint do
  {
    -1 => "calibrating",
    111 => "rookie",
    1111 => "iron",
    3111 => "bronze",
    5111 => "silver",
    9111 => "gold",
    13111 => "platinum",
    19111 => "diamond",
    25111 => "master",
    999999999 => "master"
  }.each do |lp, name|
    league_point = described_class.new(lp)
    it { expect(league_point.name).to eq name }
    it { expect(league_point).to public_send("be_#{name}") }
  end
end
