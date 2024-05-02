# frozen_string_literal: true

class ArrayEnumType < ActiveRecord::Type::Value
  attr_reader :mapping, :subtype

  delegate :type, to: :subtype

  def initialize(mapping, subtype)
    @mapping = mapping
    @subtype = subtype
    super()
  end

  def cast(value)
    value.map { |v| mapping.key(v) || v }
  end

  def serialize(value)
    subtype.serialize(value.map { |v| mapping.fetch(v, v) })
  end

  def deserialize(value)
    cast(subtype.deserialize(value))
  end
end
