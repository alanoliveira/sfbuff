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

  def vs
    battle.challengers.send(vs_side)
  end

  def result
    case battle.winner_side
    when side then "win"
    when nil then "draw"
    else "lose"
    end.inquiry
  end

  private

  def vs_side
    p1? ? "p2" : "p1"
  end

  def set_ranked_variation
    calculator_class = battle.mr_calculator
    return if calculator_class.nil?

    calculator = calculator_class.new(my_mr: master_rating, vs_mr: vs.master_rating)
    self.master_rating_variation = case result
    when "win" then calculator.win_variation
    when "lose" then calculator.lose_variation
    else calculator.draw_variation
    end
  end
end
