class Statistics
  include Enumerable

  COLUMNS = Score.members.map(&:to_s)

  def initialize(rel)
    @rel = rel.extending(ScoreScope)
  end

  def each(&)
    connection.select_all(@rel.select_score).map do |row|
      [ Score.new(**row.extract!(*COLUMNS)), row ]
    end.each(&)
  end

  def cache_key
    @rel.cache_key
  end

  private

  def connection
    @rel.connection
  end

  module ScoreScope
    def select_score
      COLUMNS.map { |name| send(name).as(name) }.then { select _1 }
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
