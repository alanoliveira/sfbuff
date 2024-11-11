module Buckler
  class Client
    CONFIG_ATTRS = %i[email password base_url user_agent logger]

    attr_reader *CONFIG_ATTRS

    def initialize(**config, &connection_middleware)
      @connection_middleware = connection_middleware
      CONFIG_ATTRS.each do |name|
        value = config[name] || Buckler.configuration.public_send(name)
        instance_variable_set("@#{name}", value)
      end
    end

    def next_api(locale: "en")
      Api::NextApi.new(connection: build_api_connection(locale))
    end

    def reset_build_id!
      @next_data = nil
    end

    def reset_authentication!
      @auth_cookies = nil
    end

    private

    def site_api
      Api::SiteApi.new(connection: build_connection)
    end

    def auth_api
      Api::AuthApi.new(connection: build_connection)
    end

    def next_data
      @next_data ||= site_api.next_data
    end

    def auth_cookies
      @auth_cookies ||= auth_api.authenticate(email:, password:)
    end

    def build_id
      next_data.fetch("buildId")
    end

    def build_api_connection(locale)
      build_connection do |conf|
        conf.path_prefix = "/6/buckler/_next/data/#{build_id}/#{locale}/"
        conf.headers["cookie"] = auth_cookies
        conf.use Middleware::NextApiErrorHandler, client: self
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
  end
end
