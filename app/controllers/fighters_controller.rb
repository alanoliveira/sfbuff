class FightersController < ApplicationController
  before_action :set_fighter

  def synchronize
    if @fighter.synchronized?
      return redirect_back fallback_location: fighter_path(@fighter), status: :see_other
    end

    @synchronization = SynchronizationRequest.create(fighter_id: @fighter.id)
    @synchronization.process_later!
  end

  private

  def set_fighter
    @fighter = Fighter.find_or_initialize_by(id: params[:id])
  end
end
