class Matchup < ApplicationRecord
  enum :result, { "loss" => -1, "win" => 1, "draw" => 0 }

  belongs_to :battle, foreign_key: :replay_id

  scope :scoreboard, Scoreboard

  def readonly?
    true
  end
end
