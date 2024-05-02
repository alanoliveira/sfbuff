# frozen_string_literal: true

class Battle < ApplicationRecord
  enum :battle_type, Buckler::BATTLE_TYPES.invert, instance_methods: false, validate: { allow_nil: true }
  enum :battle_subtype, Buckler::BATTLE_SUBTYPES.invert, instance_methods: false, validate: { allow_nil: true }

  has_many :challangers, dependent: :destroy

  default_scope { order(:played_at) }

  def challanger(side)
    challangers.find { |c| c.side == "p#{side}" }
  end
end
