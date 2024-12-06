require "rails_helper"

RSpec.describe MatchupChart, type: :model do
  let(:matchup_chart) { described_class.new(Matchup.new(home: Challenger.p1, away: Challenger.p2)) }

  before do
    create_list(:battle, 4, p1: build(:p1, :lose), p2: build(:p2, :win, character: Character["ryu"], control_type: ControlType["C"]))
    create_list(:battle, 3, p1: build(:p1, :lose), p2: build(:p2, :win, character: Character["ryu"], control_type: ControlType["M"]))
    create_list(:battle, 2, p1: build(:p1, :win), p2: build(:p2, :lose, character: Character["jamie"], control_type: ControlType["C"]))
  end

  it do
    expect(matchup_chart).to include(
      { character: Character["ryu"], control_type: ControlType["C"], score: Score.new(win: 0, lose: 4, draw: 0) },
      { character: Character["ryu"], control_type: ControlType["M"], score: Score.new(win: 0, lose: 3, draw: 0) },
      { character: Character["jamie"], control_type: ControlType["C"], score: Score.new(win: 2, lose: 0, draw: 0) },
      { character: Character["ken"], control_type: ControlType["C"], score: nil }
    )
  end
end
