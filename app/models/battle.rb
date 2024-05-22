# frozen_string_literal: true

class Battle < ApplicationRecord
  has_many :challengers, dependent: :destroy
  with_options class_name: 'Challenger', dependent: false, inverse_of: :battle do
    has_one :p1, -> { where(side: 1) }
    has_one :p2, -> { where(side: 2) }
  end

  default_scope { order(:played_at) }

  def self.pov
    joins('INNER JOIN challengers AS player ON battles.id = player.battle_id
           INNER JOIN challengers AS opponent ON battles.id = opponent.battle_id
                  AND player.player_sid != opponent.player_sid')
  end

  def winner
    case winner_side
    when 1 then p1
    when 2 then p2
    end
  end
end
