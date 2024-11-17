class Challenger < ApplicationRecord
  enum :side, { "p1" => 1, "p2" => 2 }
  attribute :short_id, :buckler_short_id
  attribute :master_rating, :buckler_master_rating
  attribute :league_point, :buckler_league_point
  attribute :rounds, :buckler_round, array: true
  store_accessor :ranked_variation, [ :master_rating_variation, :league_point_variation ]

  belongs_to :battle

  before_save :set_ranked_variation

  def league
    league_point.name
  end
  delegate *Buckler::LEAGUE_THRESHOLD.values.map { "#{_1}?" }, to: :league_point

  def actual_master_rating
    return Buckler::INITIAL_MASTER_RATING if mr_reseted?
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
