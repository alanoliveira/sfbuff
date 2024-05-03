# frozen_string_literal: true

class Round
  attr_reader :raw

  def initialize(raw)
    @raw = raw
  end

  def win?
    !(loss? || draw?)
  end

  def loss?
    raw.zero?
  end

  def draw?
    raw == 4
  end
end
