class Battle < ApplicationRecord
  include FromReplay

  attribute :p1_rounds, :round, json_array: true
  attribute :p2_rounds, :round, json_array: true

  before_save :set_winner_side

  private

  def set_winner_side
    p1_wins = p1_rounds.count(&:win?)
    p2_wins = p2_rounds.count(&:win?)
    self.winner_side = case
    when p1_wins > p2_wins then 1
    when p2_wins > p1_wins then 2
    else 0
    end
  end
end
