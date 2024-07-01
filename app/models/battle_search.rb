# frozen_string_literal: true

class BattleSearch
  class BattleCriteria
    include ActiveModel::Model

    attr_accessor :battle_type, :played_from

    def to_criteria
      { battle_type:, played_at: (played_from..) }.compact_blank
    end
  end

  class ChallengerCriteria
    include ActiveModel::Model

    attr_accessor :player_sid, :character, :control_type

    def to_criteria
      as_json.compact_blank
    end
  end

  include ActiveModel::Model

  attr_reader :battle, :player, :opponent

  def initialize(*, **)
    @battle = BattleCriteria.new
    @player = ChallengerCriteria.new
    @opponent = ChallengerCriteria.new
    super
  end

  def battle=(attrs)
    @battle.attributes = attrs
  end

  def player=(attrs)
    @player.attributes = attrs
  end

  def opponent=(attrs)
    @opponent.attributes = attrs
  end

  def result
    return nil unless valid?

    Battle.pov.where(criteria)
  end

  private

  def criteria
    {
      battles: battle.to_criteria,
      player: player.to_criteria,
      opponent: opponent.to_criteria
    }.compact_blank
  end
end
