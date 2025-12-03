module SwitchLocale
  extend ActiveSupport::Concern

  included do
    if self < ActionController::Base
      around_action :switch_locale
    elsif self < ActionCable::Connection::Base
      around_command :switch_locale
    end
  end

  def switch_locale(&)
    locale = extract_locale_from_cookies ||
      extract_locale_from_accept_language_header ||
      I18n.default_locale
    I18n.with_locale(locale, &)
  end

  private

  def extract_locale_from_cookies
    cookies["locale"].try { |l| l if I18n.locale_available? l }
  end

  def extract_locale_from_accept_language_header
    lang = request.env["HTTP_ACCEPT_LANGUAGE"].try { _1.scan(/^[^;,]+/).first }
    lang if I18n.locale_available? lang
  end
end
