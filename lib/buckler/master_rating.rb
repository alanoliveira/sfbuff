module Buckler
  class MasterRating < SimpleDelegator
    def initialize(value)
      super(value.to_i)
    end

    def inspect
      "#<#{self.class} #{self}>"
    end
  end
end
