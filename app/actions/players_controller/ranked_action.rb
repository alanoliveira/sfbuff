# frozen_string_literal: true

class PlayersController
  class RankedAction < BaseAction
    include PeriodSearchable

    attribute :character, :integer
    attribute :period, :integer, default: 1

    attr_accessor :player_sid

    def master_rating
      @master_rating ||= challengers.where.not(mr_variation: nil)
    end

    def league_point
      @league_point ||= challengers
    end

    private

    def challengers
      Challenger
        .where(player_sid:, character:)
        .joins(:battle).where(
          battle: { played_at: period_range, battle_type: Buckler::BATTLE_TYPES[:ranked] }
        )
        .order(:played_at)
        .includes(:battle)
    end
  end
end
