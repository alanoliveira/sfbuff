# frozen_string_literal: true

module Players
  class BattlesController < BaseController
    def show
      @filter = Filter.new(filter_params)
      battles = @player.battles.where(@filter.to_criteria)
      @battles = battles.order(played_at: :desc).includes(:challengers).page(params[:page])
      @rivals = battles.rivals
    end

    private

    def filter_params
      params
        .permit(Filter.attribute_names)
        .with_defaults(
          played_from: 1.week.ago.to_date,
          played_to: Time.zone.now.to_date
        )
    end

    class Filter
      include ActiveModel::Model
      include ActiveModel::Attributes

      model_name.param_key = ''

      attribute :player_character, :integer
      attribute :player_control_type, :integer
      attribute :opponent_character, :integer
      attribute :opponent_control_type, :integer
      attribute :battle_type, :integer
      attribute :played_from, :date, default: -> { 7.days.ago }
      attribute :played_to, :date, default: -> { Time.zone.now }

      def to_criteria
        {
          battle_type:,
          played_at: (played_from.beginning_of_day..played_to.end_of_day),
          player: { character: player_character, control_type: player_control_type }.compact_blank,
          opponent: { character: opponent_character, control_type: opponent_control_type }.compact_blank
        }.compact_blank
      end
    end
  end
end
