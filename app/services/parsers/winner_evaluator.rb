# frozen_string_literal: true

module Parsers
  class WinnerEvaluator
    def self.evaluate_winner(p1_rounds, p2_rounds)
      p1_loses = p1_rounds.filter(&:zero?).length
      p2_loses = p2_rounds.filter(&:zero?).length

      if p2_loses > p1_loses
        1
      elsif p1_loses > p2_loses
        2
      end
    end
  end
end
