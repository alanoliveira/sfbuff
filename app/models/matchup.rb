class Matchup < ApplicationRecord
  enum :result, { "loss" => -1, "win" => 1, "draw" => 0 }

  belongs_to :battle, foreign_key: :replay_id

  scope :scoreboard, Scoreboard

  def self.rivals
    Rivals.new(all)
  end

  def self.scoreboard_by_day
    group_by_day(:played_at)
      .then { it.select("#{it.group_values.last} date") }
      .scoreboard
      .each { |score, date:| [ date, score ] }
      .to_h
  end

  def readonly?
    true
  end
end
