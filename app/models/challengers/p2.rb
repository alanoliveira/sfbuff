class Challengers::P2 < Challenger
  belongs_to :battle, inverse_of: :p2
  has_one :opponent, through: :battle, source: :p1
end
