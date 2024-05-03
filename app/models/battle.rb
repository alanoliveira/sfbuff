# frozen_string_literal: true

class Battle < ApplicationRecord
  has_many :challangers, dependent: :destroy

  default_scope { order(:played_at) }

  def challanger(side)
    challangers.find { |c| c.side == "p#{side}" }
  end
end
