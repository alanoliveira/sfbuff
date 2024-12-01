class BucklerTypes::MasterRating < ActiveRecord::Type::Value
  def serialize(value)
    value.to_i
  end

  def type
    :buckler_master_rating
  end

  private

  def cast_value(value)
    ::MasterRating.new(value)
  end
end
