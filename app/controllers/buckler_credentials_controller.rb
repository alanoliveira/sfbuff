class BucklerCredentialsController < ApplicationController
  skip_before_action :require_timezone

  def show
    buckler_credential = BucklerCredential.take
    return render plain: "BucklerCredential not available", status: 503 unless buckler_credential

    render json: buckler_credential.as_json.tap { it["auth_cookie"] &&= "[FILTERED]" }
  end
end
