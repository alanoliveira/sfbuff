require 'rails_helper'

RSpec.describe Match do
  describe ".daily_results" do
    let(:daily_results) { described_class.where(home_fighter_id: 111222333).daily_results }

    before do
      3.times { create(:battle, :p1_win, p1_fighter_id: 111222333, p2_fighter_id: 333222111, played_at: "2020-01-01") }
      2.times { create(:battle, :p2_win, p1_fighter_id: 111222333, p2_fighter_id: 333222111, played_at: "2020-01-01") }
      2.times { create(:battle, :draw, p1_fighter_id: 111222333, p2_fighter_id: 333222111, played_at: "2020-01-02") }
    end

    it do
      expect(daily_results).to contain_exactly(
        [ Date.parse("2020-01-02"), Score.new(wins: 0, losses: 0, draws: 2) ],
        [ Date.parse("2020-01-01"), Score.new(wins: 3, losses: 2, draws: 0) ]
      )
    end
  end
end
