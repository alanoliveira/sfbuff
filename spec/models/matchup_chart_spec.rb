require "rails_helper"

RSpec.describe MatchupChart do
  let(:matchup_chart) { described_class.new(matches) }
  let(:matches) { Match.where(home_fighter_id: 111222333) }

  before do
    2.times { create(:battle, :draw,   p1_fighter_id: 111222333, p2_character_id: 1, p2_input_type_id: 0) }
    3.times { create(:battle, :p2_win, p1_fighter_id: 111222333, p2_character_id: 1, p2_input_type_id: 1) }
    4.times { create(:battle, :p1_win, p1_fighter_id: 111222333, p2_character_id: 1, p2_input_type_id: 1) }
    2.times { create(:battle, :p1_win, p1_fighter_id: 111222333, p2_character_id: 1, p2_input_type_id: 1) }
    3.times { create(:battle, :p2_win, p1_fighter_id: 111222333, p2_character_id: 2, p2_input_type_id: 0) }
  end

  describe "#get" do
    it { expect(matchup_chart.get(character: 1, input_type: 0)).to eq Score.new(wins: 0, losses: 0, draws: 2) }
    it { expect(matchup_chart.get(character: 1, input_type: 1)).to eq Score.new(wins: 6, losses: 3, draws: 0) }
    it { expect(matchup_chart.get(character: 2, input_type: 0)).to eq Score.new(wins: 0, losses: 3, draws: 0) }
    it { expect(matchup_chart.get(character: 2, input_type: 1)).to eq Score.new(wins: nil, losses: nil, draws: nil) }
  end

  describe "#sum" do
    it { expect(matchup_chart.sum).to eq Score.new(wins: 6, losses: 6, draws: 2) }

    context "when there is no match" do
      before { Battle.delete_all }

      it { expect(matchup_chart.sum).to eq Score.empty }
    end
  end
end
