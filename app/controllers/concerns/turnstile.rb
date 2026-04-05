module Turnstile
  extend ActiveSupport::Concern

  included do
    before_action :require_human_verification, if: :turnstile_enabled?
  end

  class_methods do
    def skip_human_verification(**options)
      skip_before_action :require_human_verification, **options
    end
  end

  private

  def turnstile_enabled?
    Rails.env.production? && !ENV["SFBUFF_TURNSTILE_DISABLED"].present?
  end

  def require_human_verification
    return if session[:verified_at] && session[:verified_at] > 1.day.ago

    session[:return_to_after_authenticating] = request.url
    redirect_to turnstile_path
  end
end
