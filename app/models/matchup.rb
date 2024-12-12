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

  delegate :count, to: :relation
  delegate :each, to: :to_a

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
    RUBY
  end

  def load
    @data ||= begin
      data = relation.pluck("id", "home.id", "away.id", Arel.sql(RESULT_SELECT))
      battles = Battle.includes(:challengers).where(id: data.map(&:first)).index_by(&:id)

      data.map do |battle_id, home_id, away_id, result|
        {
          battle: battles[battle_id],
          home: battles[battle_id].challengers.find { |c| c.id == home_id },
          away: battles[battle_id].challengers.find { |c| c.id == away_id },
          result:
        }
      end
    end
  end
  alias to_a load

  def loaded?
    @data.present?
  end

  def performance
    relation.extending(Performance)
  end

  def cache_version
    relation.order(:id).last.try(:cache_version)
  end

  def cache_key
    "#{model_name.cache_key}/query-#{query_signature}"
  end

  def to_key
    [ query_signature ]
  end

  private

  def query_signature
    ActiveSupport::Digest.hexdigest(relation.to_sql)
  end

  attr_reader :battle, :home, :away

  def relation
    battle.joins(JOIN_STATEMENT).with(home:, away:)
  end
end
