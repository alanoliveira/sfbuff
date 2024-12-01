class LeaguePoint < NumericAttribute
  LEAGUE_THRESHOLD = {
    -1 => "calibrating",
    0 => "rookie",
    1000 => "iron",
    3000 => "bronze",
    5000 => "silver",
    9000 => "gold",
    13000 => "platinum",
    19000 => "diamond",
    25000 => "master"
  }.freeze

  LEAGUE_THRESHOLD.values.each { |league| define_method("#{league}?") { league == self.league } }

  def league
    threshold = LEAGUE_THRESHOLD.keys.select { |it| self >= it }.max
    LEAGUE_THRESHOLD[threshold]
  end

  def inspect
    "#<#{self.class} #{league}:#{to_i}>"
  end
end
