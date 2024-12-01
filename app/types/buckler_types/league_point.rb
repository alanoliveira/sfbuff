class BucklerTypes::LeaguePoint < ActiveRecord::Type::Value
  def serialize(value)
    value.to_i
  end

  def type
    :buckler_league_point
  end

  private

  def cast_value(value)
    LeaguePoint.new(value)
  end
end
