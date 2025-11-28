class RoundType < ActiveModel::Type::Value
  def cast_value(value)
    case value
    when Integer then Round[value]
    else value
    end
  end

  def serialize(value)
    value.to_i
  end

  def type
    :round
  end
end
