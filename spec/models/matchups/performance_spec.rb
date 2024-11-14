require "rails_helper"

RSpec.describe Matchup::Performance do
  describe "#sum" do
    let(:sum) { Matchup.where_home(side: 1).performance.sum }

    it "returns the sum of all Scores" do
      2.times { create(:battle, p1: build(:p1, :win), p2: build(:p2, :lose)) }
      3.times { create(:battle, p1: build(:p1, :lose), p2: build(:p2, :win)) }
      4.times { create(:battle, p1: build(:p1, :draw), p2: build(:p2, :draw)) }

      expect(sum).to have_attributes(total: 9, win: 2, lose: 3, draw: 4, diff: -1)
    end
  end

  describe "#group_by_matchup" do
    subject(:group_by_matchup) { Matchup.where_home(side: 1).performance.group_by_matchup }

    it "returns results grouped by character and control_type" do
      2.times { create(:battle, p1: build(:p1, :win), p2: build(:p2, :lose, character: 1, control_type: 1)) }
      3.times { create(:battle, p1: build(:p1, :lose), p2: build(:p2, :win, character: 3, control_type: 0)) }

      expect(group_by_matchup).to include(
        [ { "character" => 1, "control_type" => 1 }, an_object_having_attributes(total: 2) ],
        [ { "character" => 3, "control_type" => 0 }, an_object_having_attributes(total: 3) ],
      )
    end
  end

  describe "#group_by_rival" do
    subject(:group_by_rival) { Matchup.where_home(side: 1).performance.group_by_rival }

    it "returns results grouped by character, control_type, short_id and name" do
      2.times { create(:battle, p1: build(:p1), p2: build(:p2, character: 1, control_type: 1, short_id: 123_456_789, name: "hogehoge")) }
      3.times { create(:battle, p1: build(:p1), p2: build(:p2, character: 3, control_type: 0, short_id: 987_654_321, name: "fugafuga")) }

      expect(group_by_rival).to include(
        [ { "character" => 1, "control_type" => 1, "short_id" => 123_456_789, "name" => "hogehoge" }, an_object_having_attributes(total: 2) ],
        [ { "character" => 3, "control_type" => 0, "short_id" => 987_654_321, "name" => "fugafuga" }, an_object_having_attributes(total: 3) ],
      )
    end
  end

  describe "#favorites" do
    subject(:favorites) { Matchup.where_home(side: 1).performance.group(away: [ :character ]).select(away: [ :character ]).favorites }

    it do
      2.times { create(:battle, p1: build(:p1), p2: build(:p2, character: 1)) }
      3.times { create(:battle, p1: build(:p1), p2: build(:p2, character: 3)) }
      4.times { create(:battle, p1: build(:p1), p2: build(:p2, character: 2)) }

      expect(favorites).to start_with(
        [ { "character" => 2 }, an_object_having_attributes(total: 4) ],
        [ { "character" => 3 }, an_object_having_attributes(total: 3) ],
        [ { "character" => 1 }, an_object_having_attributes(total: 2) ],
      )
    end

    describe "#tormentors" do
      subject(:tormentors) { Matchup.where_home(side: 1).performance.group(away: [ :character ]).select(away: [ :character ]).tormentors }

      it do
        2.times { create(:battle, p1: build(:p1, :lose), p2: build(:p2, :win, character: 1)) }
        3.times { create(:battle, p1: build(:p1, :lose), p2: build(:p2, :win, character: 3)) }
        4.times { create(:battle, p1: build(:p1, :lose), p2: build(:p2, :win, character: 2)) }
        2.times { create(:battle, p1: build(:p1, :win), p2: build(:p2, :lose, character: 2)) }

        expect(tormentors).to start_with(
          [ { "character" => 3 }, an_object_having_attributes(diff: -3) ],
          [ { "character" => 2 }, an_object_having_attributes(diff: -2) ],
          [ { "character" => 1 }, an_object_having_attributes(diff: -2) ],
        )
      end
    end

    describe "#victims" do
      subject(:victims) { Matchup.where_home(side: 1).performance.group(away: [ :character ]).select(away: [ :character ]).victims }

      it do
        2.times { create(:battle, p1: build(:p1, :win), p2: build(:p2, :lose, character: 1)) }
        3.times { create(:battle, p1: build(:p1, :win), p2: build(:p2, :lose, character: 3)) }
        4.times { create(:battle, p1: build(:p1, :win), p2: build(:p2, :lose, character: 2)) }
        2.times { create(:battle, p1: build(:p1, :lose), p2: build(:p2, :win, character: 2)) }

        expect(victims).to start_with(
          [ { "character" => 3 }, an_object_having_attributes(diff: 3) ],
          [ { "character" => 2 }, an_object_having_attributes(diff: 2) ],
          [ { "character" => 1 }, an_object_having_attributes(diff: 2) ],
        )
      end
    end
  end
end
