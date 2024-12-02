class BucklerTypes::HomeId < ActiveRecord::Type::Value
  def serialize(value)
    value.to_i
  end

  def type
    :buckler_home_id
  end

  private

  def cast_value(value)
    HomeId.new(value)
  end
end
