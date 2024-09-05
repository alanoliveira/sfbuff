Score = Data.define(:win, :lose, :draw, :total, :diff) do
  def win_percent
    return 0 if total.zero?
    (win / total.to_f) * 100
  end

  def lose_percent
    return 0 if total.zero?
    (lose / total.to_f) * 100
  end

  def draw_percent
    return 0 if total.zero?
    (draw / total.to_f) * 100
  end

  def +(other)
    Score.new(*[ deconstruct, other.deconstruct ].transpose.map(&:sum))
  end
end
