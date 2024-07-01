# frozen_string_literal: true

class PlayersController
  class RankedAction < BaseAction
    include PeriodSearchable

    model_name.route_key = 'ranked_player'

    attribute :character, :integer
    attribute :period, :integer, default: 1

    attr_accessor :player_sid

    def master_rating
      @master_rating ||= ranked_history.master_rating(played_at: period_range)
    end

    def league_point
      @league_point ||= ranked_history.league_point(played_at: period_range)
    end

    private

    def ranked_history
      @ranked_history = RankedHistory.new(player_sid, character)
    end
  end
end
