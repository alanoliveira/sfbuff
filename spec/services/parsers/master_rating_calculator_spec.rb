# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Parsers::MasterRatingCalculator do
  let(:calculator) { described_class.new }

  describe '#call' do
    [
      {
        p1_mr: 1882,
        p2_mr: 1668,
        winner_side: 1,
        want_p1: 4,
        want_p2: -4
      },
      {
        p1_mr: 1642,
        p2_mr: 1671,
        winner_side: 1,
        want_p1: 9,
        want_p2: -9
      },
      {
        p1_mr: 1595,
        p2_mr: 1645,
        winner_side: 1,
        want_p1: 9,
        want_p2: -9
      },
      {
        p1_mr: 2043,
        p2_mr: 2002,
        winner_side: 1,
        want_p1: 7,
        want_p2: -7
      },
      {
        p1_mr: 1882,
        p2_mr: 1668,
        winner_side: 1,
        want_p1: 4,
        want_p2: -4
      },
      {
        p1_mr: 1651,
        p2_mr: 1662,
        winner_side: 1,
        want_p1: 8,
        want_p2: -8
      },
      {
        p1_mr: 1839,
        p2_mr: 1901,
        winner_side: 1,
        want_p1: 9,
        want_p2: -9
      },
      {
        p1_mr: 1757,
        p2_mr: 1766,
        winner_side: 2,
        want_p1: -8,
        want_p2: 8
      },
      {
        p1_mr: 1857,
        p2_mr: 1905,
        winner_side: 2,
        want_p1: -7,
        want_p2: 7
      },
      {
        p1_mr: 1736,
        p2_mr: 1650,
        winner_side: nil,
        want_p1: -2,
        want_p2: 2
      },
      {
        p1_mr: 2000,
        p2_mr: 0,
        winner_side: 2,
        want_p1: nil,
        want_p2: nil
      }
    ].each do |example|
      it 'calculate the correct value' do
        expect(described_class.new(example[:p1_mr], example[:p2_mr], example[:winner_side])).to have_attributes(
          p1_variation: example[:want_p1],
          p2_variation: example[:want_p2]
        )
      end
    end
  end
end
