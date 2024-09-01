Score = Data.define(:win, :lose, :draw) do
  def total
    win + lose + draw
  end

  def diff
    win - lose
  end

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
end
