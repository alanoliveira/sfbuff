Matchup::Score = Data.define(:wins, :losses, :draws) do
  def total
    wins + losses + draws
  end

  def diff
    wins - losses
  end

  def ratio
    (wins + (draws.to_f / 2)) / total.to_f * 100
  end

  def +(other)
    self.class.new(wins + other.wins, losses + other.losses, draws + other.draws)
  end
end
