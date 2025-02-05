class FightersController < ApplicationController
  before_action :set_fighter

  def update
    return render turbo_stream: turbo_stream.remove([ @fighter, "synchronization" ]) if @fighter.synchronized?

    @fighter.synchronize_later
  end

  private

  def set_fighter
    @fighter = Fighter.find(params[:id])
  end
end
