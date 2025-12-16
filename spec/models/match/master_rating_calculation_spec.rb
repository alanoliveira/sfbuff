require "rails_helper"

RSpec.describe Match::MasterRatingCalculation do
  before do
    allow(MasterRatingCalculator).to receive(:new).with(home_mr: 100, away_mr: 200, result: Result::WIN).and_return(
      instance_double(MasterRatingCalculator, calculate: 42)
    )
  end

  context "when it is a ranked match and home and away have mr" do
    let(:match) { Match.find_by(replay_id: create(:battle, :ranked, :p1_win, p1_mr: 100, p2_mr: 200).replay_id) }

    it { expect(match).to be_mr_match }
    it { expect(match.home_mr_variation).to eq 42 }
  end

  context "when it is not a ranked match" do
    let(:match) { Match.find_by(replay_id: create(:battle, :custom_room, :p1_win, p1_mr: 100, p2_mr: 200).replay_id) }

    it { expect(match).not_to be_mr_match }
    it { expect(match.home_mr_variation).to be_nil }
  end

  context "when it is a ranked match but home or away does not have mr" do
    let(:match) { Match.find_by(replay_id: create(:battle, :ranked, :p1_win, p1_mr: 100, p2_mr: 0).replay_id) }

    it { expect(match).not_to be_mr_match }
    it { expect(match.home_mr_variation).to be_nil }
  end
end
