class ApplicationController < ActionController::Base
  include Pagy::Method
  include Sessionizer
  include ModalVariant
  include SwitchLocale
  include SwitchTimezone

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes
end
