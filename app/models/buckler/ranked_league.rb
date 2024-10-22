class Buckler
  module RankedLeague
    def self.for_league_point(league_point)
      threshold = Enums::LEAGUE_THRESHOLD.keys.select { |it| league_point >= it }.max
      Enums::LEAGUE_THRESHOLD[threshold]
    end
  end
end
