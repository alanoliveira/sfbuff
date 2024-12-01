class BucklerTypes::ControlType < ActiveRecord::Type::Value
  def serialize(value)
    value.to_i
  end

  def type
    :buckler_control_type
  end

  private

  def cast_value(value)
    ControlType.new(value)
  end
end
