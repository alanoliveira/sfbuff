# frozen_string_literal: true

class Challenger < ApplicationRecord
  enum :side, { p1: 1, p2: 2 }, instance_methods: false
  attribute :rounds, :round, array: true

  belongs_to :battle
end
