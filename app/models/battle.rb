# frozen_string_literal: true

class Battle < ApplicationRecord
  has_many :challangers, dependent: :destroy

  default_scope { order(:played_at) }

  def p1
    challangers.find { |c| c.side == 'p1' }
  end

  def p2
    challangers.find { |c| c.side == 'p2' }
  end

  def self.pov
    includes(:challangers)
      .joins('INNER JOIN challangers AS player ON battles.id = player.battle_id')
      .joins('INNER JOIN challangers AS opponent ON battles.id = opponent.battle_id
              AND player.player_sid != opponent.player_sid')
  end

  def winner
    case p1.rounds.filter(&:win?).length - p2.rounds.filter(&:win?).length
    when 1.. then p1
    when ..-1 then p2
    end
  end
end
