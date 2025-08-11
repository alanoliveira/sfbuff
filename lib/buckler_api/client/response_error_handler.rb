module BucklerApi
  class Client::ResponseErrorHandler
    def self.handle!(response)
      new(response).handle!
    end

    def handle!
      case
      when page_not_found? then Errors::PageNotFound
      when unauthorized? then Errors::Unauthorized
      when under_maintenance? then Errors::UnderMaintenance
      when rate_limit_exceeded? then Errors::RateLimitExceeded
      when buckler_server_error? then Errors::BucklerServerError
      else Errors::HttpError
      end.then { raise it, response }
    end

    private

    attr_accessor :response

    def initialize(response)
      @response = response
    end

    private

    # Checks when it tried to access a non existent page (not a non existent resource).
    # This is used to handle when the build_id of the buckler changed.
    def page_not_found?
      response.status == 404 and response.headers["Content-Type"] == "text/html"
    end

    def unauthorized?
      response.status == 403
    end

    def under_maintenance?
      response.status == 503
    end

    def rate_limit_exceeded?
      response.status == 405 && response.headers["x-amzn-waf-action"]
    end

    def buckler_server_error?
      (500..599).cover? response.status
    end
  end
end
