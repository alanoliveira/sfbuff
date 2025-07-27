class Battle < ApplicationRecord
  include HasChallengers

  def to_param
    replay_id
  end
end
