class HumanVerification
  cattr_reader :cf_turnstile_site_key, default: ENV["SFBUFF_CF_TURNSTILE_SITE_KEY"]
  cattr_reader :cf_turnstile_secret_key, default: ENV["SFBUFF_CF_TURNSTILE_SECRET_KEY"]

  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :ip_address
  attribute :token

  def validate
    turnstile_client = Cloudflare::TurnstileClient.new
    turnstile_client.validate(
      token:,
      ip_address:,
      secret_key: cf_turnstile_secret_key
    )
  end

  def valid?
    response = validate
    response["success"]
  end
end
