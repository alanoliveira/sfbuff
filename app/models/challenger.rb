# frozen_string_literal: true

class Challenger < ApplicationRecord
  enum :side, { p1: 1, p2: 2 }

  belongs_to :battle
end
