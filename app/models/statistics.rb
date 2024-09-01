class Statistics
  include Enumerable

  SCORE_SELECT = Challenger.results.map do |k, v|
    ArelHelpers.count_if(Challenger.arel_table[:result].eq(v)).as(k)
  end

  def initialize(rel)
    @rel = rel.select(SCORE_SELECT)
  end

  def each(&)
    @rel.connection.select_all(@rel, "Statistics#for").filter_map do |row|
      score = Score.new(**row.extract!(*Challenger.results.keys))
      { score:, values: row } if score.total.positive?
    end.each(&)
  end
end
