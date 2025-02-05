class FightersController < ApplicationController
  before_action :set_fighter, except: :index

  layout "application", only: :index

  def index
    @fighter_search = begin
      fighter_search = FighterSearch.new(query: params[:q])
      fighter_search if fighter_search.valid?
    end if params[:q]
  end

  def update
    return render turbo_stream: turbo_stream.remove([ @fighter, "synchronization" ]) if @fighter.synchronized?

    @fighter.synchronize_later
  end

  private

  def set_fighter
    @fighter = Fighter.find(params[:id])
  end
end
