class ApplicationController < ActionController::Base
  include SwitchTimezone

  before_action :require_timezone
  around_action :switch_timezone
end
