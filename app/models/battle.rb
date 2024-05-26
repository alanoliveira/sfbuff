# frozen_string_literal: true

class Battle < ApplicationRecord
  with_options class_name: 'Challenger', dependent: :destroy, inverse_of: :battle do
    has_one :p1, -> { where(side: 1) }
    has_one :p2, -> { where(side: 2) }
  end
  has_one :raw_battle, dependent: :destroy, primary_key: :replay_id, foreign_key: :replay_id, inverse_of: false

  default_scope { order(:played_at) }

  def self.pov
    extending(Pov)
  end

  def winner
    case winner_side
    when 1 then p1
    when 2 then p2
    end
  end
end
