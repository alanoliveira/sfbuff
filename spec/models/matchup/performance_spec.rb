require "rails_helper"

RSpec.describe Matchup::Performance, type: :model do
  let(:performance) do
    Matchup
      .new(home: Challenger.where(side: "p1"), away: Challenger.where(side: "p2"))
      .performance
  end

  before do
    create_list(:battle, 3, :custom_room, p1: build(:p1, :win), p2: build(:p2, :lose))
    create_list(:battle, 2, :ranked, p1: build(:p1, :lose), p2: build(:p2, :win))
  end

  it "iterates over group, score" do
    expect(performance).to match([
      [ {}, Score.new(win: 3, lose: 2, draw: 0) ]
    ])
  end

  context "when grouping results" do
    it do
      expect(performance.select("battle_type").group("battle_type")).to match([
        [ { "battle_type" => BattleType["ranked"].to_i }, Score.new(win: 0, lose: 2, draw: 0) ],
        [ { "battle_type" => BattleType["custom_room"].to_i }, Score.new(win: 3, lose: 0, draw: 0) ]
      ])
    end
  end
end
