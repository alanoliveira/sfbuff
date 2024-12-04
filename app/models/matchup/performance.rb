module Matchup::Performance
  def sum
    map(&:second).reduce(Score.zero) do |total, item|
      total + item
    end
  end

  def select_values
    super | [
      win_column.as("win"),
      lose_column.as("lose"),
      ArelHelpers.count_if(arel_column("battles.winner_side").eq(nil)).as("draw"),
      Arel::Nodes::Subtraction.new(win_column, lose_column).as("diff"),
      Arel::Nodes::Count.new([ 1 ]).as("total")
    ]
  end

  def load
    @records ||= with_connection do |conn|
      conn.select_all(self, "#{__FILE__}:#{__LINE__}", async: @async).then do |rows|
        rows.map do |row|
          row.extract!("diff", "total") # these values are only used to order by
          score = Score.new(**row.extract!(*Score.members.map(&:to_s)))
          [ row, score ]
        end
      end
    end
  end

  private

  def win_column
    ArelHelpers.count_if(arel_column("battles.winner_side").eq(arel_column("home.side")))
  end

  def lose_column
    ArelHelpers.count_if(arel_column("battles.winner_side").eq(arel_column("away.side")))
  end
end
