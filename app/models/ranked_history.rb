class RankedHistory
  include ActiveModel::API
  include Enumerable

  attr_reader :short_id, :character, :date_range

  def initialize(short_id, character, date_range: nil)
    @short_id = short_id
    @character = character
    @date_range = date_range
  end

  def each
    relation.each do |challenger|
      battle = challenger.battle
      yield({
        replay_id: battle.replay_id,
        played_at: battle.played_at,
        master_rating: challenger.master_rating,
        league_point: challenger.league_point,
        mr_variation: challenger.master_rating_variation,
        lp_variation: challenger.league_point_variation
      })
    end
  end

  private

  def relation
    challenger_rel.joins(:battle).includes(:battle).merge(battle_rel)
  end

  def battle_rel
    Battle
      .ranked
      .tap { _1.where!(played_at: date_range) if date_range.present? }
      .select(:id, :replay_id, :played_at)
      .order(:played_at)
  end

  def challenger_rel
    Challenger
      .where(short_id:, character:)
      .select(:battle_id, :master_rating, :league_point, :ranked_variation)
  end
end
