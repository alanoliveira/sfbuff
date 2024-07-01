# frozen_string_literal: true

class PlayersController
  class MatchupChartAction < BaseAction
    include PeriodSearchable

    model_name.route_key = 'matchup_chart_player'

    attribute :character, :integer
    attribute :period, :integer, default: 1
    attribute :battle_type, :integer

    attr_accessor :player_sid

    def battles
      @battles ||= Battle.pov.where(
        played_at: period_range,
        player: { player_sid:, character: }
      ).then do |rel|
        battle_type.present? ? rel.where(battle_type:) : rel
      end
    end
  end
end
