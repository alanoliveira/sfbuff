require 'rails_helper'

RSpec.describe Battle::MrCalculator do
  subject(:calculator) { described_class.new(battle, calculator_class: DummyCalculator) }
  class DummyCalculator
    def initialize(_mr_a, _mr_b); end
    def win = 10
    def lose = -10
    def draw = 5
  end

  context "when p1 wins" do
    let(:battle) { build(:battle, p1: build(:p1, :win), p2: build(:p2, :lose)) }

    it { expect(calculator.p1_variation).to be 10 }
    it { expect(calculator.p2_variation).to be -10 }
  end

  context "when p2 wins" do
    let(:battle) { build(:battle, p1: build(:p1, :lose), p2: build(:p2, :win)) }

    it { expect(calculator.p1_variation).to be -10 }
    it { expect(calculator.p2_variation).to be 10 }
  end

  context "when it is a draw" do
    let(:battle) { build(:battle, p1: build(:p1, :draw), p2: build(:p2, :draw)) }

    it { expect(calculator.p1_variation).to be 5 }
    it { expect(calculator.p2_variation).to be 5 }
  end
end
