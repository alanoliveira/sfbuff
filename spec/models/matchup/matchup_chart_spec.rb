require 'rails_helper'

RSpec.describe Matchup::MatchupChart, type: :model do
  let(:matchup_chart) { described_class.new(matchup) }

  let(:matchup) { Matchup.new(home_fighter_id: me[:fighter_id]) }

  let(:me)  { { fighter_id: generate(:fighter_id) } }

  before do
    2.times { create_match(result: :p1_win, p1: me, p2: { character: 1, input_type: 0 }) }
    3.times { create_match(result: :p1_win, p1: me, p2: { character: 1, input_type: 1 }) }
  end

  def matchup_chart_item(score:, character:, input_type:)
    score = Score.new(**score) if score
    matchup_matching = an_object_having_attributes(away_character: character, away_input_type: input_type)
    an_object_having_attributes(score:, matchup: matchup_matching, character:, input_type:)
  end

  it do
    expect(matchup_chart).to include(
      matchup_chart_item(score: { win: 2, lose: 0, draw: 0 }, character: Character[1], input_type: InputType[0]),
      matchup_chart_item(score: { win: 3, lose: 0, draw: 0 }, character: Character[1], input_type: InputType[1]),
      matchup_chart_item(score: nil, character: Character[2], input_type: InputType[0]),
    )
  end
end
