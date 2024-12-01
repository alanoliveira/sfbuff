class BucklerTypes::Character < ActiveRecord::Type::Value
  def serialize(value)
    value.to_i
  end

  def type
    :buckler_character
  end

  private

  def cast_value(value)
    Character.new(value)
  end
end
