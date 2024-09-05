class Statistics
  include Enumerable

  SCORE_SELECT = Challenger.results.map do |k, v|
    ArelHelpers.count_if(Challenger.arel_table[:result].eq(v)).as(k)
  end.push(
    # the below values are eagerly calculated in the query because postgres
    # don't allow to use expressions in order by (for example `order by (win - lose)`)
    Arel::Nodes::Count.new([ 1 ]).as("total"),
    Arel::Nodes::Subtraction.new(
      ArelHelpers.count_if(Challenger.arel_table[:result].eq(Challenger.results["win"])),
      ArelHelpers.count_if(Challenger.arel_table[:result].eq(Challenger.results["lose"])),
    ).as("diff")
  )

  def initialize(rel)
    @rel = rel.select(SCORE_SELECT)
  end

  def each(&)
    @rel.connection.select_all(@rel, "Statistics#for").filter_map do |row|
      score = Score.new(**row.extract!(*Challenger.results.keys, "total", "diff"))
      { score:, values: row } if score.total.positive?
    end.each(&)
  end
end
