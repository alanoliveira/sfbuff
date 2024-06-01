# frozen_string_literal: true

class ApplicationController < ActionController::Base
  around_action :switch_locale, :switch_timezone

  def switch_locale(&)
    locale = extract_locale_from_accept_language_header ||
             extract_locale_from_cookies ||
             I18n.default_locale
    I18n.with_locale(locale, &)
  end

  def switch_timezone(&)
    Time.use_zone(extract_timezone_from_cookies, &)
  end

  private

  def extract_locale_from_cookies
    cookies['locale'].try { |l| l if I18n.locale_available? l }
  end

  def extract_locale_from_accept_language_header
    lang = request.env['HTTP_ACCEPT_LANGUAGE'].try { _1.scan(/^[^;,]+/).first }
    lang if I18n.locale_available? lang
  end

  def extract_timezone_from_cookies
    cookies['timezone'].try { ActiveSupport::TimeZone[_1] }
  end
end
