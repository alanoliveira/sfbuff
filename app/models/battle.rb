class Battle < ApplicationRecord
  enum :battle_type, { "ranked" => 1, "casual_match" => 2, "battle_hub" => 3, "custom_room" => 4 }
  has_one :p1, class_name: "Challengers::P1", dependent: :destroy
  has_one :p2, class_name: "Challengers::P2", dependent: :destroy

  scope :by_matchup, ->(home: Challenger.all, away: Challenger.all) { with(home:, away:).joins(:home, :away).where("home.id != away.id") }

  def challengers
    [ p1, p2 ].compact
  end
end
