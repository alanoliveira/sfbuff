class FightersController < ApplicationController
  before_action :set_fighter
  rate_limit to: 10, within: 1.minutes, only: :synchronize

  def synchronize
    if @fighter.synchronized?
      return redirect_back fallback_location: fighter_path(@fighter), status: :see_other
    end

    @synchronization_request = SynchronizationRequest.create(fighter_id: @fighter.id)
    @synchronization_request.process_later!
  end

  private

  def set_fighter
    @fighter = Fighter.find_or_initialize_by(id: params[:id])
  end
end
