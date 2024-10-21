class Challenger < ApplicationRecord
  LEAGUE_THRESHOLD = {
    0 => "rookie",
    1000 => "iron",
    3000 => "bronze",
    5000 => "silver",
    9000 => "gold",
    13000 => "platinum",
    19000 => "diamond",
    25000 => "master"
  }

  enum :result, %w[draw win lose]
  enum :side, { "p1" => 1, "p2" => 2 }
  decorate_attributes([ :rounds ]) { |_, subtype| RoundsType.new(subtype) }
  store_accessor :ranked_variation, [ :master_rating_variation, :league_point_variation ]

  belongs_to :battle

  before_save :set_result
  before_save :set_ranked_variation

  delegate *LEAGUE_THRESHOLD.values.map { "#{_1}?" }, to: :league

  def calibrating?
    league_point.negative?
  end

  def league
    threshold = LEAGUE_THRESHOLD.keys.select { |it| league_point >= it }.max
    (LEAGUE_THRESHOLD[threshold] || "").inquiry
  end

  def vs
    battle.challengers.send(vs_side)
  end

  def mr_variation
    calculator_class = battle.mr_calculator
    return if calculator_class.nil?

    calculator = calculator_class.new(my_mr: master_rating, vs_mr: vs.master_rating)
    return calculator.win_variation if win?
    return calculator.lose_variation if lose?
    calculator.draw_variation
  end

  private

  def vs_side
    p1? ? "p2" : "p1"
  end

  def set_result
    self.result = case rounds.count(&:win?) - rounds.count(&:lose?)
    when (..-1) then "lose"
    when (1..) then "win"
    when 0 then "draw"
    end
  end

  def set_ranked_variation
    # TODO: remove below guard clause after run migration 20241021071237_add_ranked_variation_to_challengers
    return unless has_attribute?("ranked_variation")
    self.master_rating_variation = mr_variation
  end
end
