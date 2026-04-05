module Turnstile
  extend ActiveSupport::Concern

  included do
    before_action :require_human_verification
  end

  class_methods do
    def skip_human_verification(**options)
      skip_before_action :require_human_verification, **options
    end
  end

  private

  def require_human_verification
    return if session[:human_verified]

    redirect_to turnstile_path
  end
end
