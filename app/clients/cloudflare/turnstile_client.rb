class Cloudflare::TurnstileClient < ApplicationClient
  self.base_url = "https://challenges.cloudflare.com"

  def validate(token:, ip_address:, secret_key:)
    response = connection.post "turnstile/v0/siteverify" do |req|
      req.headers["Content-Type"] = "application/json"
      req.body = {
        "secret" => secret_key,
        "response" => token,
        "remoteip" => ip_address
      }.to_json
    end

    response.body
  end

  private

  def configure_connection(conn)
    conn.headers["User-Agent"] = nil
    conn.response :json
  end
end
