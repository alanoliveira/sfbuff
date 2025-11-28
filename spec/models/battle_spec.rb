require 'rails_helper'

RSpec.describe Battle do
  let(:battle) { build(:battle) }

  describe "setting winner side on saving" do
    context "when p1 is the winner" do
      before { battle.assign_attributes(p1_rounds: [ Round::V ], p2_rounds: [ Round::L ]) }

      it { expect { battle.save }.to change(battle, :winner_side).to(1) }
    end

    context "when p2 is the winner" do
      before { battle.assign_attributes(p1_rounds: [ Round::L ], p2_rounds: [ Round::V ]) }

      it { expect { battle.save }.to change(battle, :winner_side).to(2) }
    end

    context "when it is a draw" do
      before { battle.assign_attributes(p1_rounds: [ Round::D ], p2_rounds: [ Round::D ]) }

      it { expect { battle.save }.to change(battle, :winner_side).to(0) }
    end
  end
end
