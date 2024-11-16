class Challenger < ApplicationRecord
  enum :side, { "p1" => 1, "p2" => 2 }
  decorate_attributes([ :rounds ]) { |_, subtype| RoundsType.new(subtype) }
  decorate_attributes([ :league_point ]) { |_, subtype| LeaguePointType.new(subtype) }
  decorate_attributes([ :master_rating ]) { |_, subtype| MasterRatingType.new(subtype) }
  store_accessor :ranked_variation, [ :master_rating_variation, :league_point_variation ]

  belongs_to :battle

  before_save :set_ranked_variation

  def league
    league_point.name
  end
  delegate *Buckler::Enums::LEAGUE_THRESHOLD.values.map { "#{_1}?" }, to: :league_point

  def actual_master_rating
    return Buckler::Enums::INITIAL_MASTER_RATING if mr_reseted?
    master_rating
  end

  # IMPORTANT:
  # This method returns a false positive if (quite unlikely) the mr is really 0
  def mr_reseted?
    master_rating.zero? && master?
  end

  private

  def set_ranked_variation
    self.master_rating_variation = battle.mr_calculator.try("#{side}_variation")
  end
end
