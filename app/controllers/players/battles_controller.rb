class Players::BattlesController < ApplicationController
  include PlayerScoped

  layout "players"
  before_action :set_battles_filter_form

  def show
    result = @battles_filter_form.submit
    @battles = result.ordered.reverse_order.page(params[:page]).preload(:challengers)
    @statistics = Statistics.new(result)

    render partial: "battle_list", locals: { battles: @battles } if turbo_frame_request_id == "battle-list"
  end

  def rivals
    result = @battles_filter_form.submit
    @rivals = Rivals.new(result.limit(8))

    render partial: "rivals", locals: { battles: @battles } if turbo_frame_request_id == "battle-list"
  end

  private

  def set_battles_filter_form
    @battles_filter_form = Players::BattlesFilterForm.new(player: @player).fill(params)
  end
end
