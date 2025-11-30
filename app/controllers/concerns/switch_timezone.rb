module SwitchTimezone
  extend ActiveSupport::Concern

  included do
    if self < ActionController::Base
      around_action :switch_timezone
      before_action :require_timezone
    elsif self < ActionCable::Connection::Base
      around_command :switch_timezone
    end
  end

  class_methods do
    def allow_ignore_timezone(**options)
      skip_before_action :require_timezone, **options
    end
  end

  def switch_timezone(&)
    Time.use_zone(extract_timezone_from_cookies, &)
  end

  def require_timezone
    render inline: "<p>Setting timezone...</p>", layout: "application" unless cookies["timezone"]
  end

  private

  def extract_timezone_from_cookies
    cookies["timezone"].try { ActiveSupport::TimeZone[_1] }
  end
end
