module Challenger::Scoring
  extend ActiveSupport::Concern

  SCORING_SELECT = <<~SELECT
    COUNT(cached_result = 1 OR NULL) AS win,
    COUNT(cached_result = -1 OR NULL) AS lose,
    COUNT(cached_result = 0 OR NULL) AS draw,
    SUM(cached_result) AS diff,
    COUNT(1) AS total
  SELECT

  included do
    before_save { self.cached_result = result }
  end

  class_methods do
    def scoreboard
      return all.to_enum(:scoreboard) unless block_given?
      lease_connection.select_rows(select(SCORING_SELECT)).each do |data|
        yield Score.new(win: data[-5], lose: data[-4], draw: data[-3]), *data[..-6]
      end
    end
  end
end
