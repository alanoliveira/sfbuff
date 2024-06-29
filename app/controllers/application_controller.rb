# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Internationalizable

  around_action :switch_locale, :switch_timezone
end
