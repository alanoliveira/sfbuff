class ApplicationController < ActionController::Base
  include Pagy::Method
  include Sessionizer
  include ModalVariant
  include SwitchLocale
  include SwitchTimezone

  rescue_from ActionController::TooManyRequests, with: :too_many_requests

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  etag { Rails.application.config.git_revision }
  etag { I18n.locale.name }
  after_action -> { no_store } if Rails.env.development?

  private

  def too_many_requests
    respond_to do |format|
      format.html { render html: helpers.too_many_requests_toast_alert, layout: true }
      format.turbo_stream { render turbo_stream: helpers.too_many_requests_toast_alert }
    end
  end
end
