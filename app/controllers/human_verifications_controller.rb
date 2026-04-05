class HumanVerificationsController < ApplicationController
  skip_human_verification

  def create
    human_verification = HumanVerification.new(verification_params)
    if human_verification.valid?
      session[:verified_at] = Time.zone.now
      redirect_to session.delete(:return_to_after_authenticating) || root_url
    else
      head :forbidden
    end
  end

  private

  def verification_params
    {
      token: params["cf-turnstile-response"],
      ip_address: request.remote_ip
    }
  end
end
