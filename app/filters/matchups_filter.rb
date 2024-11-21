class MatchupsFilter < ApplicationFilter
  def played_from(played_from)
    played_from = played_from.to_date.beginning_of_day
    relation.where(played_at: (played_from..))
  rescue ArgumentError
    relation.none
  end

  def played_to(played_to)
    played_to = played_to.to_date.end_of_day
    relation.where(played_at: (..played_to))
  rescue ArgumentError
    relation.none
  end

  def battle_type(battle_type)
    relation.where(battle_type:)
  end

  %i[short_id character control_type].each do |name|
    class_eval <<-RUBY, __FILE__, __LINE__ + 1
      def #{name}(val) = relation.where(home: { #{name}: val })
      def vs_#{name}(val) = relation.where(away: { #{name}: val })
    RUBY
  end
end
