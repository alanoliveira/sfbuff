module BucklerApi::Errors
  class Error < StandardError; end

  class HttpError < Error
    def initialize(response)
      @response = response
      super("the server responded with status #{response.status}")
    end
  end

  class UnderMaintenance < HttpError; end
  class RateLimitExceeded < HttpError; end
  class Unauthorized < HttpError; end
  class PageNotFound < HttpError; end
end
