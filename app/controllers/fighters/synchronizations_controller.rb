class Fighters::SynchronizationsController < ApplicationController
  include FighterScoped

  rate_limit to: 10, within: 1.minutes, only: :create

  def create
    if @fighter.synchronized?
      return redirect_back fallback_location: fighter_path(@fighter), status: :see_other
    end

    @synchronization_request = SynchronizationRequest.create(fighter_id: @fighter.id)
    @synchronization_request.process_later!
  end
end
