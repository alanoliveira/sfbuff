module BucklerApi
  BASE_URL = ENV.fetch("BUCKLER_BASE_URL", "https://www.streetfighter.com")
  USER_AGENT = ENV["BUCKLER_USER_AGENT"]

  class << self
    attr_writer :logger
    attr_accessor :email, :password

    def logger
      @logger ||= Logger.new(IO::NULL)
    end

    def client
      @client ||= Client.new(default_connection)
    end

    private

    def default_connection
      Connection.new(
        adapter: FaradayAdapter,
        build_id: StrategySelector.new(-> { ENV["BUCKLER_BUILD_ID"] }, BuildIdStrategies::Faraday),
        auth_cookies: StrategySelector.new(-> { ENV["BUCKLER_AUTH_COOKIES"] }, AuthCookiesStrategies::Selenium.new(email:, password:)),
      )
    end

    def respond_to_missing?(...)
      client.respond_to?(...)
    end

    def method_missing(method_name, ...)
      client.public_send(method_name, ...)
    end
  end

  class HttpError < StandardError
    def initialize(response)
      @response = response
      super("the server responded with status #{response.status}")
    end
  end

  class UnderMaintenance < HttpError; end
  class RateLimitExceeded < HttpError; end
end
