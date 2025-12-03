class Match::ResultAggregation
  include Enumerable

  def initialize(relation)
    @relation = relation.select(
      "COUNT(result = #{Result::WIN} OR NULL) AS wins",
      "COUNT(result = #{Result::LOSS} OR NULL) AS losses",
      "COUNT(result = #{Result::DRAW} OR NULL) AS draws",
      "SUM(result) AS diff",
      "COUNT(1) AS total"
    )
  end

  def each(&)
    ApplicationRecord.with_connection { |conn| conn.select_all(@relation) }.map do |row|
      score_data = row.extract!("wins", "losses", "draws", "diff", "total")
      score = Score.new(**score_data.except("diff", "total"))
      [ row, score ]
    end.each(&)
  end

  def total
    ApplicationRecord.with_connection { |conn| conn.select_one(@relation) }.then do |row|
      Score.new(**row.except("diff", "total"))
    end
  end
end
