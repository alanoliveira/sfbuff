module Matchup
  module Results
    SELECT_STATEMENT = <<-SQL.squeeze(" ")
      "battles"."id",
      CASE
      WHEN "battles"."winner_side" = "home"."side" THEN 'win'
      WHEN "battles"."winner_side" = "away"."side" THEN 'lose'
      ELSE 'draw'
      END "result"
    SQL

    def select_values
      super | [ SELECT_STATEMENT ]
    end

    def load
      @records ||= with_connection do |conn|
        conn.select_rows(self, "#{__FILE__}:#{__LINE__}", async: @async).then(&:to_h)
      end
    end
  end
end
