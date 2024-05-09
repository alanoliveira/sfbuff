# frozen_string_literal: true

class Battle < ApplicationRecord
  has_many :challangers, dependent: :destroy

  default_scope { order(:played_at) }

  def challanger(side)
    challangers.find { |c| c.side == "p#{side}" }
  end

  def winner
    p1 = challanger(1)
    p2 = challanger(2)

    case p1.rounds.filter(&:win?).length - p2.rounds.filter(&:win?).length
    when 1.. then p1
    when ..-1 then p2
    end
  end
end
