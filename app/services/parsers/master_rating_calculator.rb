# frozen_string_literal: true

module Parsers
  class MasterRatingCalculator
    attr_reader :p1_mr, :p2_mr, :winner_side

    def initialize(p1_mr, p2_mr, winner_side)
      @p1_mr = p1_mr
      @p2_mr = p2_mr
      @winner_side = winner_side
    end

    def p1_variation
      return if neutral?

      (16 * (minuend(1) - base(p2_mr - p1_mr))).round
    end

    def p2_variation
      return if neutral?

      (16 * (minuend(2) - base(p1_mr - p2_mr))).round
    end

    private

    def neutral?
      [p1_mr, p2_mr].any?(&:zero?)
    end

    def minuend(player_side)
      case winner_side
      when nil then 0.5
      when player_side then 1
      else 0
      end
    end

    def base(diff)
      1 / (1 + (10**(diff / 400.0)))
    end
  end
end
