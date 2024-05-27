# frozen_string_literal: true

class PlayersController
  class RankedAction < BaseAction
    include Rails.application.routes.url_helpers

    PERIOD = { day: 1, week: 2, month: 3 }.freeze

    attribute :character, :integer
    attribute :period, :integer

    attr_accessor :player

    def master_rating_data
      challengers.where.not(mr_variation: nil).map do |challenger|
        tooltip = format('%<points>d %<variation>+d', points: challenger.master_rating,
                                                      variation: challenger.mr_variation)
        {
          points: challenger.master_rating + challenger.mr_variation,
          tooltip:,
          played_at: challenger.battle.played_at,
          battle_url: battle_path(challenger.battle.replay_id)
        }
      end
    end

    def league_point_data
      challengers.map do |challenger|
        {
          points: challenger.league_point,
          tooltip: challenger.league_point,
          played_at: challenger.battle.played_at,
          battle_url: battle_path(challenger.battle.replay_id)
        }
      end
    end

    def character
      attributes['character'] || @player.main_character
    end

    private

    def period_range
      case period
      when PERIOD[:week] then (1.week.ago..)
      when PERIOD[:month] then (1.month.ago..)
      else (1.day.ago..)
      end
    end

    def challengers
      Challenger
        .where(player_sid: @player.sid, character:)
        .joins(:battle).where(
          battle: { played_at: period_range, battle_type: 1 }
        )
        .order(:played_at)
        .includes(:battle)
    end
  end
end
