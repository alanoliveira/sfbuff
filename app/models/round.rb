# frozen_string_literal: true

class Round
  attr_reader :raw

  def initialize(raw)
    @raw = raw
  end

  def win?
    !(lose? || draw?)
  end

  def lose?
    raw.zero?
  end

  def draw?
    raw == 4
  end
end
