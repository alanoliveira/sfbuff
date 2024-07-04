# frozen_string_literal: true

module Players
  class RankedsController < BaseController
    def show
      @filter = Filter.new(filter_params)

      @ranked_history = RankedHistory.new(@player.sid, @filter.character).tap do |it|
        it.played_at = @filter.period.to_datetime_range
      end
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
      attribute :period, :period
    end
  end
end
