module SwitchTimezone
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
