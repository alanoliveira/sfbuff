class Battle < ApplicationRecord
  include FromReplay

  attribute :p1_rounds, :round, json_array: true
  attribute :p2_rounds, :round, json_array: true
end
