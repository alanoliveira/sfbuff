require "rails_helper"

RSpec.describe Matchup, type: :model do
  subject(:matchup) do
    Matchup.new(
      battle: Battle.where(battle_type: BattleType["ranked"]),
      home: Challenger.where(character: Character["ryu"]),
      away: Challenger.where(character: Character["ken"]),
    )
  end

  it do
    expected_battles = [
      create(:battle, :ranked, p1: build(:p1, :win, character: Character["ryu"]), p2: build(:p2, :lose, character: Character["ken"]))
        .then { |b| an_object_having_attributes(battle: b, home: b.p1, away: b.p2, result: "win") },
      create(:battle, :ranked, p1: build(:p1, :win, character: Character["ken"]), p2: build(:p2, :lose, character: Character["ryu"]))
        .then { |b| an_object_having_attributes(battle: b, home: b.p2, away: b.p1, result: "lose") },
      create(:battle, :ranked, p1: build(:p1, :draw, character: Character["ryu"]), p2: build(:p2, :draw, character: Character["ken"]))
        .then { |b| an_object_having_attributes(battle: b, home: b.p1, away: b.p2, result: "draw") }
    ]

    create(:battle, :custom_room, p1: build(:p1, character: Character["ryu"]), p2: build(:p2, character: Character["ken"]))
    create(:battle, :ranked, p1: build(:p1, character: Character["ken"]), p2: build(:p2, character: Character["ken"]))

    expect(matchup).to contain_exactly(*expected_battles)
  end
end
