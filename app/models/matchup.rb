class Matchup
  Item = Data.define(:battle, :home, :away) do
    def result
      case battle.winner_side
      when home.side_before_type_cast then "win"
      when away.side_before_type_cast then "lose"
      else "draw"
      end
    end
  end

  include ActiveModel::API
  include Enumerable

  def initialize(battle: nil, home: nil, away: nil)
    @battle = battle || Battle.all
    @home = home || Challenger.all
    @away = away || Challenger.all
  end

  %i[battle home away].each do |rel_name|
    class_eval(<<-RUBY, __FILE__, __LINE__+1)
      def where_#{rel_name}(value)
        #{rel_name} = value.is_a?(Hash) ? self.#{rel_name}.where(value) : self.#{rel_name}.merge(value)
        #{name}.new(battle:, home:, away:)
      end

      def where_#{rel_name}!(value)
        value.is_a?(Hash) ? self.#{rel_name}.where!(value) : self.#{rel_name}.merge!(value)
        self
      end
    RUBY
  end

  %i[limit offset order].each do |method_name|
    class_eval(<<-RUBY, __FILE__, __LINE__+1)
      def #{method_name}(...)
        battle = self.battle.send(:#{method_name}, ...)
        #{name}.new(battle:, home:, away:)
      end
    RUBY
  end

  delegate :count, :to_sql, :cache_key, to: :relation

  def each(&)
    records.each(&)
  end

  def records
    load
    @records
  end
  alias to_a records

  def load
    @records ||= begin
      data = relation.pluck("id", "home.id", "away.id")
      battles = Battle.includes(:challengers).where(id: data.map(&:first)).index_by(&:id)
      data.map do |battle_id, home_id, away_id|
        battle = battles[battle_id]
        home, away = battle.challengers.partition { |c| c.id == home_id }.flatten
        Item.new(battle, home, away)
      end
    end

    self
  end

  def relation
    battle.with(home:, away:).joins(<<-JOIN)
      INNER JOIN "home" ON "home".battle_id = "battles"."id"
      INNER JOIN "away" ON "away".battle_id = "battles"."id"
                       AND "away"."side" = CASE WHEN "home"."side" = 1 THEN 2 ELSE 1 END
    JOIN
  end

  def cache_version
    relation.order(:id).last.cache_version
  end

  def performance
    Performance.new(relation)
  end

  private

  attr_reader :battle, :home, :away
end
