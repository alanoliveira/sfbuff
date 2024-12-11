class Matchup
  include ActiveModel::API
  include Enumerable

  RESULT_SELECT = <<-SQL.squeeze(" ")
    CASE
    WHEN "battles"."winner_side" = "home"."side" THEN 'win'
    WHEN "battles"."winner_side" = "away"."side" THEN 'lose'
    ELSE 'draw'
    END "result"
  SQL

  JOIN_STATEMENT = <<-SQL.squeeze(" ")
    INNER JOIN "home" ON "home".battle_id = "battles"."id"
    INNER JOIN "away" ON "away".battle_id = "battles"."id"
                     AND "away"."side" = CASE WHEN "home"."side" = 1 THEN 2 ELSE 1 END
  SQL

  attr_accessor :battle, :home, :away
  delegate :count, :cache_key, to: :relation

  def initialize(battle: nil, home: nil, away: nil)
    @battle = (battle || Battle).all
    @home = (home || Challenger).all
    @away = (away || Challenger).all
  end

  %i[limit offset order].each do |method_name|
    class_eval(<<-RUBY, __FILE__, __LINE__+1)
      def #{method_name}(...)
        #{name}.new(battle: battle.#{method_name}(...), home:, away:)
      end

      def #{method_name}!(...)
        battle.#{method_name}!(...)
        self
      end
    RUBY
  end

  def each
    data = relation.pluck("id", "home.id", "away.id", Arel.sql(RESULT_SELECT))
    battles = Battle.includes(:challengers).where(id: data.map(&:first)).index_by(&:id)

    data.each do |battle_id, home_id, away_id, result|
      yield({
        battle: battles[battle_id],
        home: battles[battle_id].challengers.find { |c| c.id == home_id },
        away: battles[battle_id].challengers.find { |c| c.id == away_id },
        result:
      })
    end
  end

  def performance
    relation.extending(Performance)
  end

  def cache_version
    home.order(:created_at).last.try(:cache_version)
  end

  private

  def relation
    battle.joins(JOIN_STATEMENT).with(home:, away:)
  end
end
