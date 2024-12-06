require "rails_helper"

RSpec.describe Rivals, type: :model do
  let(:rivals) { described_class.new(Matchup.new(home: Challenger.p1, away: Challenger.p2)) }
  let(:don) { { short_id: generate(:short_id), name: "Don", character: Character["guile"], control_type: ControlType["C"] } }
  let(:leo) { { short_id: generate(:short_id), name: "Leo", character: Character["ken"], control_type: ControlType["M"] } }
  let(:mik) { { short_id: generate(:short_id), name: "Mik", character: Character["ken"], control_type: ControlType["M"] } }
  let(:raf) { { short_id: generate(:short_id), name: "Raf", character: Character["zangief"], control_type: ControlType["C"] } }

  def mock_battle(vs:, wins: 0, loses: 0)
    create_list(:battle, wins, p1: build(:p1, :win), p2: build(:p2, :lose, **vs))
    create_list(:battle, loses, p1: build(:p1, :lose), p2: build(:p2, :win, **vs))
  end

  describe "#favorites" do
    it "returns the rivals order by most played desc" do
      mock_battle(vs: don, wins: 0, loses: 3)
      mock_battle(vs: leo, wins: 2, loses: 2)
      mock_battle(vs: mik, wins: 2, loses: 0)

      expect(rivals.favorites).to match([
        { score: Score.new(win: 2, lose: 2, draw: 0), **leo },
        { score: Score.new(win: 0, lose: 3, draw: 0), **don },
        { score: Score.new(win: 2, lose: 0, draw: 0), **mik }
      ])
    end
  end

  describe "#tormentors" do
    it "returns the rivals order by diff asc" do
      mock_battle(vs: don, wins: 5, loses: 5)
      mock_battle(vs: leo, wins: 5, loses: 8)
      mock_battle(vs: mik, wins: 6, loses: 9)
      mock_battle(vs: raf, wins: 6, loses: 4)

      expect(rivals.tormentors).to match([
        { score: Score.new(win: 6, lose: 9, draw: 0), **mik },
        { score: Score.new(win: 5, lose: 8, draw: 0), **leo },
        { score: Score.new(win: 5, lose: 5, draw: 0), **don },
        { score: Score.new(win: 6, lose: 4, draw: 0), **raf }
      ])
    end
  end

  describe "#victims" do
    it "returns the rivals order by diff desc" do
      mock_battle(vs: don, wins:  5, loses: 5)
      mock_battle(vs: leo, wins:  8, loses: 5)
      mock_battle(vs: mik, wins:  9, loses: 6)
      mock_battle(vs: raf, wins:  4, loses: 6)

      expect(rivals.victims).to match([
        { score: Score.new(win: 9, lose: 6, draw: 0), **mik },
        { score: Score.new(win: 8, lose: 5, draw: 0), **leo },
        { score: Score.new(win: 5, lose: 5, draw: 0), **don },
        { score: Score.new(win: 4, lose: 6, draw: 0), **raf }
      ])
    end
  end
end
