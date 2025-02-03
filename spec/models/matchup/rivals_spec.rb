require 'rails_helper'

RSpec.describe Matchup::Rivals, type: :model do
  let(:rivals) { described_class.new(matchup, limit) }

  let(:matchup) { Matchup.new(home_fighter_id: me[:fighter_id]) }
  let(:limit) { 10 }

  let(:me)  { { fighter_id: generate(:fighter_id) } }
  let(:riv_a_1_1) { { character: Character[1], input_type: InputType[1], name: "riv_a_1_1", fighter_id: generate(:fighter_id) } }
  let(:riv_b_1_1) { { character: Character[1], input_type: InputType[1], name: "riv_b_1_1", fighter_id: generate(:fighter_id) } }
  let(:riv_b_1_0) { riv_b_1_1.dup.merge(input_type: InputType[0]) }

  def rival_item(win:, lose:, draw:, character:, input_type:, name:, fighter_id:)
    matchup_matching = an_object_having_attributes(away_character: character, away_input_type: input_type)
    an_object_having_attributes(score: Score.new(win:, lose:, draw:), matchup: matchup_matching, character:, input_type:, name:, fighter_id:)
  end

  describe "#favorites" do
    before do
      1.times { create_match(result: :draw, p1: me, p2: riv_a_1_1) }
      3.times { create_match(result: :p1_win, p1: me, p2: riv_a_1_1) }
      3.times { create_match(result: :p2_win, p1: me, p2: riv_a_1_1) }
      5.times { create_match(result: :p2_win, p1: riv_b_1_1, p2: me) }
      4.times { create_match(result: :p1_win, p1: riv_b_1_0, p2: me) }
    end

    it do
      expect(rivals.favorites).to match([
        rival_item(win: 3, lose: 3, draw: 1, **riv_a_1_1),
        rival_item(win: 5, lose: 0, draw: 0, **riv_b_1_1),
        rival_item(win: 0, lose: 4, draw: 0, **riv_b_1_0)
      ])
    end
  end

  describe "#victims" do
    before do
      5.times { create_match(result: :p1_win, p1: me, p2: riv_a_1_1) }
      5.times { create_match(result: :p2_win, p1: me, p2: riv_a_1_1) }
      2.times { create_match(result: :p1_win, p1: riv_b_1_1, p2: me) }
      4.times { create_match(result: :p2_win, p1: riv_b_1_1, p2: me) }
      1.times { create_match(result: :p1_win, p1: riv_b_1_0, p2: me) }
      3.times { create_match(result: :p2_win, p1: riv_b_1_0, p2: me) }
    end

    it do
      expect(rivals.victims).to match([
        rival_item(win: 4, lose: 2, draw: 0, **riv_b_1_1),
        rival_item(win: 3, lose: 1, draw: 0, **riv_b_1_0),
        rival_item(win: 5, lose: 5, draw: 0, **riv_a_1_1)
      ])
    end
  end

  describe "#tormentors" do
    before do
      5.times { create_match(result: :p1_win, p1: me, p2: riv_a_1_1) }
      5.times { create_match(result: :p2_win, p1: me, p2: riv_a_1_1) }
      4.times { create_match(result: :p1_win, p1: riv_b_1_1, p2: me) }
      2.times { create_match(result: :p2_win, p1: riv_b_1_1, p2: me) }
      3.times { create_match(result: :p1_win, p1: riv_b_1_0, p2: me) }
      1.times { create_match(result: :p2_win, p1: riv_b_1_0, p2: me) }
    end

    it do
      expect(rivals.tormentors).to match([
        rival_item(win: 2, lose: 4, draw: 0, **riv_b_1_1),
        rival_item(win: 1, lose: 3, draw: 0, **riv_b_1_0),
        rival_item(win: 5, lose: 5, draw: 0, **riv_a_1_1)
      ])
    end
  end
end
