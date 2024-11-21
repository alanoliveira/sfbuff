require "rails_helper"

RSpec.describe Matchup::Results do
  subject(:results) { Matchup.where(home: { side: 1 }).results }

  it "returns the sum of all Scores" do
    create(:battle, id: 1, p1: build(:p1, :win), p2: build(:p2, :lose))
    create(:battle, id: 2, p1: build(:p1, :lose), p2: build(:p2, :win))
    create(:battle, id: 3, p1: build(:p1, :win), p2: build(:p2, :lose))
    create(:battle, id: 4, p1: build(:p1, :draw), p2: build(:p2, :draw))

    expect(results).to match(
      1 => "win",
      2 => "lose",
      3 => "win",
      4 => "draw",
    )
  end
end
