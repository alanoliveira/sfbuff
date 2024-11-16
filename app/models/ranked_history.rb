class RankedHistory
  Item = Data.define(:replay_id, :played_at, :master_rating, :master_rating_variation,
    :league_point, :league_point_variation) do
    def self.from_challenger(challenger)
      new(
        replay_id: challenger.battle.replay_id,
        played_at: challenger.battle.played_at,
        master_rating: challenger.actual_master_rating,
        master_rating_variation: challenger.master_rating_variation,
        league_point: challenger.league_point,
        league_point_variation: challenger.league_point_variation,
      )
    end
  end

  include Enumerable

  attr_accessor :short_id, :character, :played_at

  def initialize(short_id:, character:, played_at: nil)
    @short_id = short_id
    @character = character
    @played_at = played_at
  end

  def each(...)
    challenger_criteria
      .includes(:battle).merge(battle_criteria)
      .reject { _1.master? && _1.master_rating_variation.nil? }
      .reject(&:calibrating?)
      .map { Item.from_challenger(_1) }
      .each(...)
  end

  private

  def battle_criteria
    Battle.ranked.ordered.select(:replay_id, :played_at).tap do |battle|
      battle.where!(played_at:) if played_at.present?
    end
  end

  def challenger_criteria
    Challenger.where(short_id:, character:)
      .select(:battle_id, :master_rating, :league_point, :ranked_variation)
  end
end
