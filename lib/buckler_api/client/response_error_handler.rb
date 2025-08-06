module BucklerApi
  class Client::ResponseErrorHandler
    def self.handle!(response)
      new(response).handle!
    end

    def handle!
      case
      when build_id_changed? then Errors::PageNotFound
      when unauthorized? then Errors::Unauthorized
      when under_maintenance? then Errors::UnderMaintenance
      when rate_limit_exceeded? then Errors::RateLimitExceeded
      else Errors::HttpError
      end.then { raise it, response }
    end

    private

    attr_accessor :response

    def initialize(response)
      @response = response
    end

    private

    def build_id_changed?
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
  end
end
