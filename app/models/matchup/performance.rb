class Matchup::Performance
  include Enumerable

  def initialize(relation)
    @relation = relation
  end

  delegate :to_sql, :cache_key, to: :relation

  %i[select group limit order].each do |method_name|
    class_eval(<<-RUBY, __FILE__, __LINE__+1)
      def #{method_name}(...)
        relation = self.relation.send(:#{method_name}, ...)
        #{name}.new(relation)
      end
    RUBY
  end

  def sum
    map(&:second).reduce(Score.zero) do |total, item|
      total + item
    end
  end

  def group_by_date(date_column)
    Arel.sql(date_column)
      .then { ArelPgHelpers.convert_tz(_1, to: Time.zone.name) }
      .then { ArelPgHelpers.date(_1) }
      .then { select(_1.as("date")).group("date") }
  end

  def each(&)
    records.each(&)
  end

  def records
    load
    @records
  end
  alias to_a records

  def load
    @records ||= relation.with_connection do |conn|
      conn.select_all(query, "#{__FILE__}:#{__LINE__}").then do |rows|
        rows.map do |row|
          row.extract!("diff", "total") # these values are only used to order by
          score = Score.new(**row.extract!(*Score.members.map(&:to_s)))
          [ row, score ]
        end
      end
    end
  end

  private

  attr_accessor :relation

  def query
    relation.select(
      win_column.as("win"),
      lose_column.as("lose"),
      ArelPgHelpers.count_if(Arel.sql("battles.winner_side").eq(nil)).as("draw"),
      Arel::Nodes::Subtraction.new(win_column, lose_column).as("diff"),
      Arel::Nodes::Count.new([ 1 ]).as("total"))
  end

  def win_column
    ArelPgHelpers.count_if(Arel.sql("battles.winner_side").eq(Arel.sql("home.side")))
  end

  def lose_column
    ArelPgHelpers.count_if(Arel.sql("battles.winner_side").eq(Arel.sql("away.side")))
  end
end
