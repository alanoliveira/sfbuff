class BucklerApi::Connection
  PATH_PREFIX = "/6/buckler/_next/data"

  attr_accessor :adapter, :build_id, :auth_cookies

  def initialize(adapter:, build_id:, auth_cookies:)
    @adapter = adapter
    @build_id = build_id
    @auth_cookies = auth_cookies
  end

  def get(path, **params)
    response = adapter.get(build_uri(path), params:, headers:)

    handle_response_error!(response) unless response.success?

    response
  end

  private

  def build_uri(path)
    URI(BucklerApi::BASE_URL).tap do |it|
      it.path = "#{PATH_PREFIX}/#{build_id}/en/#{path}"
    end
  end

  def headers
    { "cookie" => auth_cookies.to_s, "user-agent" => BucklerApi::USER_AGENT }
  end

  def handle_response_error!(response)
    build_id.renew if response.path_not_found?
    auth_cookies.renew if response.forbidden?

    if response.under_maintenance? then BucklerApi::UnderMaintenance
    elsif response.rate_limit_exceeded? then BucklerApi::RateLimitExceeded
    else BucklerApi::HttpError
    end.then { raise _1, response }
  end
end
