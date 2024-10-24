class ApplicationController < ActionController::Base
  include Pagy::Backend
  include Internationalizable

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :set_turbo_modal_variant
  around_action :switch_locale, :switch_timezone

  private

  def set_turbo_modal_variant
    request.variant << :modal if turbo_frame_request_id == "turbo-modal"
  end
end
