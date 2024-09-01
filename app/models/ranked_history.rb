class RankedHistory
  include Enumerable

  attr_reader :short_id, :character, :played_at

  def initialize(short_id:, character:, played_at: nil)
    @short_id = short_id
    @character = character
    @played_at = played_at
  end

  def each
    battles.map do |b|
      c = b.challengers.find { _1.short_id == short_id }
      yield RankedResult.new(
        replay_id: b.replay_id,
        played_at:  b.played_at,
        master_rating: c.master_rating,
        league_point: c.league_point,
        mr_variation: c.mr_variation
      )
    end
  end

  private

  def battles
    battle_rel = Battle.ranked.ordered
    battle_rel.where!(played_at:) if played_at.present?
    battle_rel.joins(:challengers).preload(:challengers)
      .where(challengers: { short_id:, character: })
  end
end
