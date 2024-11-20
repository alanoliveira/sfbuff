module Matchup
  class << self
    private

    def respond_to_missing?(...)
      Battle.respond_to?(...) || super
    end

    def method_missing(method_name, ...)
      Battle.extending(self).send(method_name, ...)
    end
  end

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

  def performance
    extending(Performance)
  end

  def results
    @results ||= extending(Results)
      .unscope(:order, :limit, :offset)
      .where(id: records.pluck(:id))
      .to_h
  end

  def index_with_result
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

  def reset
    @results = nil
    super
  end
end
