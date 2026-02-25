class ApplicationController < ActionController::Base
  include Pagy::Method
  include Sessionizer
  include ModalVariant
  include SwitchLocale
  include SwitchTimezone
  include TooManyRequestsHandler
  include Unindexable
  include Adsenses

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  fragment_cache_key { I18n.locale.name }
  fragment_cache_key { Time.zone.utc_offset }
  fragment_cache_key { Rails.application.config.git_revision }
  etag { Rails.application.config.git_revision }
  etag { I18n.locale.name }
  after_action -> { no_store } if Rails.env.development?

  private

  def device_detector
    @device_detector ||= DeviceDetector.new(request.user_agent)
  end
end
