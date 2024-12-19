class ApplicationController < ActionController::Base
  include Pagy::Backend
  include Internationalizable

  around_action :switch_locale, :switch_timezone
end
