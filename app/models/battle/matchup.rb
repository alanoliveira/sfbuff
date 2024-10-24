module Battle::Matchup
  [ "home", "away" ].each do |side|
    class_eval <<-RUBY
      def where_#{side}(...)
        spawn.where_#{side}!(...)
      end

      def where_#{side}!(...)
        #{side}.where!(...)
        self
      end

      def #{side}
        @#{side} ||= Challenger.all
      end
      private :#{side}
    RUBY
  end

  def index_with_result
    rel = select_result.except(:limit, :offset, :order).where(id: records.pluck(:id))
    results = rel.with_connection { |conn| conn.select_rows(rel.to_sql).to_h }
    index_with { |b| results[b.id] }
  end

  def with_values
    super | [ { home: }, { away: } ]
  end

  def joins_values
    super.dup.push <<-JOIN.squeeze(" ")
      INNER JOIN "home" ON "home".battle_id = "battles"."id"
      INNER JOIN "away" ON "away".battle_id = "battles"."id"
                       AND "away"."side" = CASE WHEN "home"."side" = 1 THEN 2 ELSE 1 END
    JOIN
  end

  private

  def select_result
    reselect(<<-SQL.squeeze(" "))
      "battles"."id",
      CASE
      WHEN "battles"."winner_side" = "home"."side" THEN 'win'
      WHEN "battles"."winner_side" = "away"."side" THEN 'lose'
      ELSE 'draw'
      END "result"
    SQL
  end
end
