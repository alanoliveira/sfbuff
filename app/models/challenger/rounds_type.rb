class Challenger
  class RoundsType < ActiveRecord::Type::Value
    attr_reader :subtype

    delegate :type, to: :subtype

    def initialize(subtype)
      @subtype = subtype
    end

    def cast(value)
      cast_value(value) unless value.nil?
    end

    def serialize(value)
      subtype.serialize value.map(&:raw)
    end

    def deserialize(value)
      cast(subtype.deserialize(value))
    end

    private

    def cast_value(value)
      value.map { |v| Round.new(v) }
    end
  end
end
