class Challenger < ApplicationRecord
  enum :side, { "p1" => 1, "p2" => 2 }
  decorate_attributes([ :rounds ]) { |_, subtype| RoundsType.new(subtype) }
  store_accessor :ranked_variation, [ :master_rating_variation, :league_point_variation ]

  belongs_to :battle

  before_save :set_ranked_variation

  def league
    Buckler::RankedLeague.for_league_point(league_point).inquiry
  end
  delegate *Buckler::Enums::LEAGUE_THRESHOLD.values.map { "#{_1}?" }, to: :league

  def result
    case battle.winner_side
    when side then "win"
    when nil then "draw"
    else "lose"
    end.inquiry
  end

  private

  def set_ranked_variation
    self.master_rating_variation = battle.mr_calculator.try("#{side}_variation")
  end
end
