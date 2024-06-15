# frozen_string_literal: true

class PlayersController
  class MatchupChartAction < BaseAction
    include PeriodSearchable

    attribute :character, :integer
    attribute :period, :integer, default: 1
    attribute :battle_type, :integer

    attr_accessor :player_sid

    def matchup_chart
      @matchup_chart ||= Battle.pov.where(
        played_at: period_range,
        player: { player_sid:, character: }
      ).then do |rel|
        battle_type.present? ? rel.where(battle_type:) : rel
      end.matchup_chart
    end
  end
end
