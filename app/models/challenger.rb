# frozen_string_literal: true

class Challenger < ApplicationRecord
  enum :side, { p1: 1, p2: 2 }, instance_methods: false
  attribute :rounds, :round, array: true

  has_one :vs, class_name: 'Challenger',
               foreign_key: :battle_id, primary_key: :battle_id,
               inverse_of: false, dependent: :destroy

  belongs_to :battle
end
