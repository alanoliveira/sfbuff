require 'rails_helper'

RSpec.describe Buckler::RankedLeague do
  describe ".for_league_point" do
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
      it { expect(described_class.for_league_point(lp)).to eq league }
    end
  end
end
