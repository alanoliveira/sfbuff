class Players::BattlesController < ApplicationController
  include PlayerScoped

  layout "players"

  def show
    @battles_filter_form = Players::BattlesFilterForm.new(player: @player).fill(params)
    result = @battles_filter_form.submit
    @battles = result.ordered.reverse_order.page(params[:page]).preload(:challengers)
  end
end
