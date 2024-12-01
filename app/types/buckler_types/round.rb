class BucklerTypes::Round < ActiveRecord::Type::Value
  def serialize(value)
    value.to_i
  end

  def type
    :buckler_round
  end

  private

  def cast_value(value)
    Round.new(value)
  end
end
