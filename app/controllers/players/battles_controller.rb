class Players::BattlesController < Players::BaseController
  before_action :set_battles_filter_form

  def show
    result = @battles_filter_form.submit
    @battles = result.ordered.reverse_order.page(params[:page]).preload(:challengers)

    cache_key = [ @player.latest_replay_id, result.cache_key ].join("-")
    cache_store.with_options expires_in: 5.minutes do |it|
      @total_pages = it.fetch("#{cache_key}-total_pages") { @battles.total_pages }
      @score = it.fetch("#{cache_key}-score") { Statistics.new(result).sum }
    end
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
