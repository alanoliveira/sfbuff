module Buckler
  class Client
    CONFIG_ATTRS = %i[email password base_url user_agent logger]

    attr_reader *CONFIG_ATTRS

    def initialize(**config, &connection_middleware)
      @error_handler_semaphore = Mutex.new
      @connection_middleware = connection_middleware
      CONFIG_ATTRS.each do |name|
        value = config[name] || Buckler.configuration.public_send(name)
        instance_variable_set("@#{name}", value)
      end
      update_next_data && update_auth_cookies
    end

    def next_api(locale: "en")
      Api::NextApi.new(connection: build_api_connection(locale))
    end

    private

    def site_api
      Api::SiteApi.new(connection: build_connection)
    end

    def auth_api
      Api::AuthApi.new(connection: build_connection)
    end

    def update_next_data
      @next_data = site_api.next_data
    end

    def update_auth_cookies
      @auth_cookies = auth_api.authenticate(email:, password:)
    end

    def build_api_connection(locale)
      build_connection do |conf|
        conf.path_prefix = "/6/buckler/_next/data/#{@next_data["buildId"]}/#{locale}/"
        conf.headers["cookie"] = @auth_cookies
        conf.use Middleware::ResponseErrorHandler, handler: method(:handle_response_error)
      end
    end

    def build_connection
      Faraday.new base_url do |conf|
        conf.response :logger, logger
        conf.headers["user-agent"] = user_agent
        conf.headers["Priority"] = "u=0,i"
        yield conf if block_given?
        @connection_middleware&.call(conf)
      end
    end

    def handle_response_error(response_env)
      analyzer = ResponseErrorAnalyzer.new(response_env)

      @error_handler_semaphore.try_lock && begin
        update_next_data if analyzer.path_not_found?
        update_auth_cookies if analyzer.forbidden?
      ensure
        @error_handler_semaphore.unlock
      end

      raise UnderMaintenance, response_env if analyzer.under_maintenance?
      raise RateLimitExceeded, response_env if analyzer.rate_limit_exceeded?

      raise HttpError, response_env
    end
  end
end
