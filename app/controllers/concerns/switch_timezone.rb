module SwitchTimezone
  extend ActiveSupport::Concern

  included do
    if self < ActionController::Base
      around_action :switch_timezone
    elsif self < ActionCable::Connection::Base
      around_command :switch_timezone
    end
  end

  def switch_timezone(&)
    Time.use_zone(extract_timezone_from_cookies, &)
  end

  private

  def extract_timezone_from_cookies
    cookies["timezone"].try { ActiveSupport::TimeZone[_1] }
  end
end
