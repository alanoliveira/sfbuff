module PlayedAtRememberable
  extend ActiveSupport::Concern

  included do
    before_action :initialize_played_at_parameters
  end

  def initialize_played_at_parameters
    reset_played_at_parameters if params[:commit] == "reset"
    params.merge!(played_from: current_played_from, played_to: current_played_to)
  end

  private

  def reset_played_at_parameters
    session[:played_from] = session[:played_to] = nil
  end

  def current_played_from
    session[:played_from] = params[:played_from] || session[:played_from] || 7.days.ago.to_date
  end

  def current_played_to
    session[:played_to] = params[:played_to] || session[:played_to] || Time.zone.now.to_date
  end
end
