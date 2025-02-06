class ApplicationController < ActionController::Base
  include VersionHeaders
  include SwitchTimezone
  include SwitchLocale

  before_action :require_timezone
  around_action :switch_timezone, :switch_locale
end
