class Players::BattlesController < Players::BaseController
  before_action :set_battles_filter_form

  def show
    result = @battles_filter_form.submit
    # it using a nested select to prevent pg from sorting before the filter
    @battles = Battle.from(result.ordered, "battles")
      .ordered.reverse_order.page(params[:page]).preload(:challengers)

    @total_pages = cache_store.fetch("#{result.cache_key}-total_pages") { @battles.total_pages }
    @scores = result.scores
  end

  def rivals
    result = @battles_filter_form.submit
    @rivals = Rivals.new(result.limit(8))
  end

  private

  def set_battles_filter_form
    @battles_filter_form = Players::BattlesFilterForm.new(player: @player).fill(params)
  end
end
