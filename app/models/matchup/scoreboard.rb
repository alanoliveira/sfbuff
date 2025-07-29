module Matchup::Scoreboard
  def self.call
    Matchup.extending(self).query
  end

  def query
    group_values.any? ? select_all : select_one
  end

  def select_all
    Enumerator.new do |y|
      lease_connection.select_all(self).map do |data|
        score = create_score(data)
        y.yield(score, **data)
      end
    end
  end

  def select_one
    create_score(lease_connection.select_one(self))
  end

  def select_values
    [
      "COUNT(result = #{Matchup::Result::WIN.to_i} OR NULL) AS wins",
      "COUNT(result = #{Matchup::Result::LOSS.to_i} OR NULL) AS losses",
      "COUNT(result = #{Matchup::Result::DRAW.to_i} OR NULL) AS draws",
      "SUM(result) AS diff",
      "COUNT(1) AS total"
    ] | super
  end

  def create_score(data)
    data.symbolize_keys!
    data.extract!(:diff, :total)
    Matchup::Score.new(**data.extract!(*Matchup::Score.members))
  end
end
