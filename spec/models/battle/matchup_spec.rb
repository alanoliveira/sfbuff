require 'rails_helper'

RSpec.describe Battle::Matchup do
  subject(:matchup) { Battle.matchup }

  before do
    create(:battle, replay_id: "A", p1: build(:p1, :win, character: 1), p2: build(:p2, :lose, character: 3))
    create(:battle, replay_id: "B", p1: build(:p1, :lose, character: 2), p2: build(:p2, :win, character: 5))
    create(:battle, replay_id: "C", p1: build(:p1, :draw, character: 2), p2: build(:p2, :draw, character: 6))
    create(:battle, replay_id: "D", p1: build(:p1, :win, character: 4), p2: build(:p2, :lose, character: 1))
  end

  it { expect(matchup.where_home(character: 1)).to have_attributes(count: 2) }
  it { expect(matchup.where_away(character: 4)).to have_attributes(count: 1) }

  describe "#index_with_result" do
    subject(:results) { matchup.where_home(character: 1).index_with_result }

    it do
      expect(results).to match(
        Battle.find_by(replay_id: "A") => "win",
        Battle.find_by(replay_id: "D") => "lose",
      )
    end
  end
end
