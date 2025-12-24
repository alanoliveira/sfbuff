class Fighters::SynchronizationsController < ApplicationController
  include FighterScoped

  rate_limit to: 5, within: 1.minutes, only: :create
  before_action :set_synchronization, only: :show

  def create
    log_session_event(params: @fighter.id)

    @fighter.save if @fighter.new_record?
    @synchronization = @fighter.synchronize_later || @fighter.current_synchronization
  end

  def show
    head :accepted unless @synchronization&.finished?
  end

  private

  def set_synchronization
    @synchronization = @fighter.current_synchronization
  end
end
