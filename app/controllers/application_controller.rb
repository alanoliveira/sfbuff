class ApplicationController < ActionController::Base
  include Pagy::Backend
  include Internationalizable

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  around_action :switch_locale, :switch_timezone
  allow_browser versions: :modern, block: :handle_outdated_browser

  private

  def handle_outdated_browser
    logger.info("Unsupported browser detected: #{request.user_agent}")
    flash.now[:danger] = t("alerts.browser_not_supported").html_safe
  end
end
