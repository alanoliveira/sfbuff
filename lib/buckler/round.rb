module Buckler
  class Round < SimpleDelegator
    def initialize(value)
      super(value.to_i)
    end

    def win?
      !lose? && !draw?
    end

    def lose?
      self == ROUNDS["l"]
    end

    def draw?
      self == ROUNDS["d"]
    end

    def to_s
      (ROUNDS.key self).upcase
    end

    def inspect
      "#<#{self.class} #{self}>"
    end
  end
end
