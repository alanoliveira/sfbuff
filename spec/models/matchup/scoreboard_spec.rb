require 'rails_helper'

RSpec.describe Matchup::Scoreboard, type: :model do
  subject(:scoreboard) { matchups.scoreboard }

  let(:matchups) { Matchup.where(home_fighter_id: 111_111_111) }

  before do
    create_matchups(wins: 7, losses: 1, draws: 2, home_fighter_id: 111_111_111, away_fighter_id: 222_222_222)
    create_matchups(wins: 3, losses: 4, draws: 0, home_fighter_id: 111_111_111, away_fighter_id: 333_333_333)
  end

  context "when matchups are not grouped" do
    it "returns a hash with the 'total' scoreboard" do
      expect(scoreboard).to have_attributes(wins: 10, losses: 5, draws: 2, total: 17, diff: 5)
    end
  end

  context "when matchups are grouped" do
    before { matchups.group!(:away_fighter_id) }

    it "returns an array of hashes with the scoreboard for each group" do
      expect(scoreboard).to contain_exactly(
        an_object_having_attributes(wins: 7, losses: 1, draws: 2, total: 10, diff: 6),
        an_object_having_attributes(wins: 3, losses: 4, draws: 0, total: 7, diff: -1),
      )
    end
  end
end
