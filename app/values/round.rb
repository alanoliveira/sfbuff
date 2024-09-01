Round = Data.define(:raw) do
  def win?
    !lose? && !draw?
  end

  def lose?
    raw == Buckler::Enums::ROUNDS["l"]
  end

  def draw?
    raw == Buckler::Enums::ROUNDS["d"]
  end

  def to_i
    raw
  end

  def eql?(other)
    raw == other.raw
  end
end
