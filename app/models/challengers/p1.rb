class Challengers::P1 < Challenger
  belongs_to :battle, inverse_of: :p1
  has_one :opponent, through: :battle, source: :p2
end
