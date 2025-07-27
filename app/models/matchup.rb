class Matchup < ApplicationRecord
  belongs_to :battle, foreign_key: :replay_id

  def readonly?
    true
  end
end
