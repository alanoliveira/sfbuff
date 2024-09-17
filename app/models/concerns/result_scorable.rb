module ResultScorable
  COLUMNS = %w[win lose draw total diff]

  def scores(&)
    connection.select_all(select(*score_select_values), "ResultScorable#scores").map do |row|
        score = Score.new(**row.extract!(*COLUMNS))
        [ row, score ]
    end.each(&)
  end

  private

  def score_select_values
    ScoreSelectBuilder.select_values
  end

  module ScoreSelectBuilder
    module_function

    def select_values
      @select_values ||= COLUMNS.map { |name| send(name).as(name) }
    end

    def win
      ArelHelpers.count_if(Challenger.arel_table[:result].eq(Challenger.results["win"]))
    end

    def lose
      ArelHelpers.count_if(Challenger.arel_table[:result].eq(Challenger.results["lose"]))
    end

    def draw
      ArelHelpers.count_if(Challenger.arel_table[:result].eq(Challenger.results["draw"]))
    end

    def total
      Arel::Nodes::Count.new([ 1 ])
    end

    def diff
      Arel::Nodes::Subtraction.new(win, lose)
    end
  end
end
