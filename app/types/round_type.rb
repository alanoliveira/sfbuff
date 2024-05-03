# frozen_string_literal: true

class RoundType < ActiveRecord::Type::Value
  def cast(value)
    Round.new(value.to_i)
  end

  def serialize(round)
    round.raw
  end
end
