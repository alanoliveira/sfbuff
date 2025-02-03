Score = Struct.new(:win, :lose, :draw) do
  def hash
    object_id ^ self.class.hash
  end

  def total
    win + lose + draw
  end

  def diff
    win - lose
  end

  def win_ratio
    win / total.to_f * 100
  end

  def +(other)
    Score.new(win: win + other.win, lose: lose + other.lose, draw: draw + other.draw)
  end

  def ~
    Score.new(win: lose, lose: win, draw:)
  end
end
