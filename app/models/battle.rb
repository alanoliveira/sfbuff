class Battle < ApplicationRecord
  include HasChallengers

  has_many :matchups, foreign_key: :replay_id

  def to_param
    replay_id
  end
end
