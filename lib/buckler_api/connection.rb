module BucklerApi
  class Connection
    PATH_PREFIX = "/6/buckler/_next/data"

    attr_accessor :configuration

    def initialize
      @configuration = ConnectionConfiguration.new
      yield @configuration
    end

    def client
      Client.new(self)
    end

    def get(path, **params)
      response = configuration.adapter.get(build_uri(path), params:, headers:)

      handle_response_error!(response) unless response.success?

      response
    end

    private

    def build_uri(path)
      URI(configuration.base_url).tap do |it|
        it.path = "#{PATH_PREFIX}/#{build_id}/en/#{path}"
      end
    end

    def headers
      { "cookie" => auth_cookies, "user-agent" => configuration.user_agent }
    end

    def build_id
      configuration.build_id_manager.current
    end

    def auth_cookies
      configuration.auth_cookies_manager.current
    end

    def handle_response_error!(response)
      configuration.build_id_manager.renew if response.path_not_found?
      configuration.auth_cookies_manager.renew if response.forbidden?

      if response.under_maintenance? then Errors::UnderMaintenance
      elsif response.rate_limit_exceeded? then Errors::RateLimitExceeded
      else Errors::HttpError
      end.then { raise it, response }
    end
  end
end
