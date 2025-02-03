require 'rails_helper'

RSpec.describe Challenger::Scoring, type: :model do
  describe "before_save" do
    context "when result is win" do
      let(:challenger) { build(:p1, :win, :with_battle) }

      it { expect { challenger.save! }.to change(challenger, :cached_result).to(Result::WIN.to_i) }
    end

    context "when result is lose" do
      let(:challenger) { build(:p1, :lose, :with_battle) }

      it { expect { challenger.save! }.to change(challenger, :cached_result).to(Result::LOSE.to_i) }
    end

    context "when result is draw" do
      let(:challenger) { build(:p1, :draw, :with_battle) }

      it { expect { challenger.save! }.to change(challenger, :cached_result).to(Result::DRAW.to_i) }
    end
  end

  describe ".scoreboard" do
    subject(:scoreboard) { challenger.scoreboard }

    before do
      create_list(:p1, 4, :win,  :with_battle, character_id: 1)
      create_list(:p1, 3, :lose, :with_battle, character_id: 1)
      create_list(:p1, 2, :draw, :with_battle, character_id: 1)
      create_list(:p1, 1, :win,  :with_battle, character_id: 2)
      create_list(:p1, 1, :lose, :with_battle, character_id: 2)
      create_list(:p1, 1, :draw, :with_battle, character_id: 2)
    end

    context "without grouping or select" do
      let(:challenger) { Challenger.where(side: 1) }

      it "iterates over the (single) ungrouped result" do
        expect(scoreboard).to contain_exactly(Score.new(win: 5, lose: 4, draw: 3))
      end
    end

    context "grouping and selecting" do
      let(:challenger) { Challenger.where(side: 1).group(:character_id).select(:character_id) }

      it "iterates over the results + selected values for each group" do
        expect(scoreboard).to contain_exactly(
          [ Score.new(win: 4, lose: 3, draw: 2), 1 ],
          [ Score.new(win: 1, lose: 1, draw: 1), 2 ]
        )
      end
    end
  end
end
