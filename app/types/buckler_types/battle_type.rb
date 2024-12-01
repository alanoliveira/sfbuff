class BucklerTypes::BattleType < ActiveRecord::Type::Value
  def serialize(value)
    value.to_i
  end

  def type
    :buckler_battle_type
  end

  private

  def cast_value(value)
    BattleType.new(value)
  end
end
