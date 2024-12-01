class BucklerTypes::ShortId < ActiveRecord::Type::Value
  def serialize(value)
    value.to_i
  end

  def type
    :buckler_short_id
  end

  private

  def cast_value(value)
    ShortId.new(value)
  end
end
