class ApplicationController < ActionController::Base
  include Pagy::Backend
  include Internationalizable

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  around_action :switch_locale, :switch_timezone

  private

  def trustable?
    # TODO: check Sec-Fetch headers
    true
  end
end
