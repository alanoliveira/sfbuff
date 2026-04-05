class HumanVerificationsController < ApplicationController
  skip_human_verification

  def create
    human_verification = HumanVerification.new(verification_params)
    if human_verification.valid?
      session[:human_verified] = true
      redirect_to root_url
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
