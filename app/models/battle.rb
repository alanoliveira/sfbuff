# frozen_string_literal: true

class Battle < ApplicationRecord
  has_many :challengers, dependent: :destroy
  has_one :raw_battle, dependent: :destroy, primary_key: :replay_id, foreign_key: :replay_id, inverse_of: false

  scope :ranked, -> { where(battle_type: Buckler::BATTLE_TYPES[:ranked]) }

  def self.pov
    extending(Pov)
  end

  def p1
    challengers.find(&:p1?)
  end

  def p2
    challengers.find(&:p2?)
  end

  def winner
    case winner_side
    when 1 then p1
    when 2 then p2
    end
  end

  def to_param
    replay_id
  end

  def ranked?
    battle_type == Buckler::BATTLE_TYPES[:ranked]
  end

  def >(other)
    played_at > other.played_at
  end
end
