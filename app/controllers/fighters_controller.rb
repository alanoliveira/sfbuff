class FightersController < ApplicationController
  rate_limit to: 10, within: 1.minutes, only: :update, with: -> { too_many_requests }

  before_action :set_fighter, except: :index

  def index
    @query = params[:q]
  end

  def update
    return head :accepted if ENV["SKIP_BUCKLER_SYNCHRONIZATION"]
    return render turbo_stream: turbo_stream.action("refresh", nil) if @fighter.synchronized?
    @fighter.save! if @fighter.new_record?
    ahoy.track("FightersController#update", { fighter_id: @fighter.id })

    @fighter.synchronize_later unless @fighter.synchronized?
  end

  private

  def set_fighter
    @fighter = Fighter.find_or_initialize_by(id: params[:id])
  end
end
