module TooManyRequestsHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActionController::TooManyRequests, with: :too_many_requests
  end

  private

  def too_many_requests
    respond_to do |format|
      format.html { render html: helpers.too_many_requests_toast_alert, layout: true, status: :too_many_requests }
      format.turbo_stream { render turbo_stream: helpers.too_many_requests_toast_alert, status: :too_many_requests }
    end
  end
end
