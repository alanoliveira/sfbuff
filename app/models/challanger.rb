# frozen_string_literal: true

class Challanger < ApplicationRecord
  enum :side, { p1: 1, p2: 2 }, instance_methods: false

  belongs_to :battle
end
