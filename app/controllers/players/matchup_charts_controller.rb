# frozen_string_literal: true

module Players
  class MatchupChartsController < BaseController
    def show
      @filter = Filter.new(filter_params)

      @battles = @player.battles.where(@filter.to_criteria)
    end

    private

    def filter_params
      params
        .permit(:character, :battle_type, :period)
        .with_defaults(
          period: 'day',
          character: @player.main_character
        )
    end

    class Filter
      include ActiveModel::Model
      include ActiveModel::Attributes

      model_name.param_key = ''

      attribute :character, :integer
      attribute :battle_type, :integer
      attribute :period, :period

      def to_criteria
        {
          played_at: period.to_datetime_range,
          battle_type:,
          player: { character: }
        }.compact_blank
      end
    end
  end
end
