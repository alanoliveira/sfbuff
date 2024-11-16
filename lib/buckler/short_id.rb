module Buckler
  class ShortId < SimpleDelegator
    def self.valid?(value)
      value.to_i >= 100_000_000
    end

    def initialize(value)
      value = value.to_i
      raise InvalidShortId, "#{value} is not a valid short id" unless self.class.valid? value
      super(value)
    end

    def inspect
      "#<#{self.class} #{self}>"
    end
  end
end
