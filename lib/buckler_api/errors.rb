module BucklerApi::Errors
  class HttpError < StandardError
    def initialize(response)
      @response = response
      super("the server responded with status #{response.status}")
    end
  end

  class UnderMaintenance < HttpError; end
  class RateLimitExceeded < HttpError; end
end
