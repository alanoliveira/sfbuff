require "rails_helper"
require_relative "a_numeric_attribute"

RSpec.describe LeaguePoint do
  it_behaves_like "a numeric attribute"

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
  }.each do |lp, league|
    league_point = described_class.new(lp)

    it { expect(league_point.league).to eq league }
    it { expect(league_point).to public_send("be_#{league}") }
  end
end
