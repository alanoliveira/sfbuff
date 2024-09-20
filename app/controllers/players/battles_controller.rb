class Players::BattlesController < Players::BaseController
  before_action :set_battles_filter_form

  def show
    result = @battles_filter_form.submit
    @battles = result.preload(:challengers).ordered.reverse_order.page(params[:page])

    @total_pages = cache([ @battles_filter_form, "total_pages" ]) { @battles.total_pages }
    @score = cache([ @battles_filter_form, "score" ]) { result.scores.first[1] }
  end

  def rivals
    @rivals = @battles_filter_form.submit.limit(8).rivals
  end

  private

  def set_battles_filter_form
    @battles_filter_form = Players::BattlesFilterForm.new(player: @player).fill(params)
  end
end
