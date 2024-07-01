# frozen_string_literal: true

class RankedHistory
  Item = Struct.new(:replay_id, :played_at, :points, :variation)

  attr_reader :player_sid, :character

  def initialize(player_sid, character)
    @player_sid = player_sid
    @character = character
  end

  def master_rating(**)
    challengers(**)
      .where.not(mr_variation: nil)
      .pluck(:replay_id, :played_at, :master_rating, :mr_variation).map { Item.new(*_1) }
  end

  def league_point(**)
    challengers(**)
      .where.not(league_point: -1)
      .pluck(:replay_id, :played_at, :league_point).map { Item.new(*_1) }
  end

  private

  def challengers(played_at: nil)
    Challenger
      .joins(:battle)
      .merge(Battle.ranked.where(played_at:))
      .where(player_sid:, character:)
      .order(played_at: :asc)
      .includes(:battle)
  end
end
