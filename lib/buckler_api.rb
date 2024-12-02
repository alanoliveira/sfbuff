module BucklerApi
  BASE_URL = ENV.fetch("BUCKLER_BASE_URL", "https://www.streetfighter.com")
  USER_AGENT = ENV["BUCKLER_USER_AGENT"]

  class HttpError < StandardError
    def initialize(response)
      @response = response
      super("the server responded with status #{response.status}")
    end
  end

  class UnderMaintenance < HttpError; end
  class RateLimitExceeded < HttpError; end
end
