class Challenger < ApplicationRecord
  enum :side, { "p1" => 1, "p2" => 2 }
  decorate_attributes([ :rounds ]) { |_, subtype| RoundsType.new(subtype) }

  belongs_to :battle
end
