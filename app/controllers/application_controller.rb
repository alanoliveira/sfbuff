class ApplicationController < ActionController::Base
  include VersionHeaders
  include SwitchTimezone
  include SwitchLocale

  before_action :require_timezone
  around_action :switch_timezone, :switch_locale
  around_action :track_slow_requests

  etag { I18n.locale.name }
  etag { Rails.application.config.git_revision }
  fragment_cache_key { I18n.locale.name }
  fragment_cache_key { Time.zone.utc_offset }

  private

  def too_many_requests
    render partial: "application/too_many_requests", status: :too_many_requests
  end

  def track_slow_requests
    start_time = Time.zone.now
    yield
    end_time = Time.zone.now
    diff = end_time - start_time
    if diff > 1.second
      ahoy.track("slow_request", params: params.to_unsafe_h, time: diff)
    end
  end
end
