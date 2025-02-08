class FightersController < ApplicationController
  rate_limit to: 10, within: 1.minutes, only: :update, with: -> { too_many_requests }

  before_action :set_fighter, except: :index

  layout "application", only: :index

  def index
    @fighter_search = begin
      fighter_search = FighterSearch.new(query: params[:q])
      fighter_search if fighter_search.valid?
    end if params[:q]
  end

  def update
    ahoy.track("FightersController#update", { fighter_id: @fighter.id })
    return render turbo_stream: turbo_stream.remove([ @fighter, "synchronization" ]) if @fighter.synchronized?

    @fighter.synchronize_later
  end

  private

  def set_fighter
    @fighter = Fighter.find(params[:id])
  end
end
