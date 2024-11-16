module Buckler
  module Api
    class HttpError < StandardError
      def initialize(response)
        @response = response
        super("the server responded with status #{response.status}")
      end
    end

    class UnderMaintenance < HttpError; end
    class RateLimitExceeded < HttpError; end

    class << self
      def build_client(
        base_url: Buckler.configuration.base_url,
        user_agent: Buckler.configuration.user_agent,
        email: Buckler.configuration.email,
        password: Buckler.configuration.password,
        logger: Buckler.configuration.logger
      )
        connection_builder = Api::ConnectionBuilder.new(base_url:, user_agent:, logger:)
        build_id_fetcher = proc do
          ENV["BUCKLER_BUILD_ID"] ||
            Api::SiteApi.new(connection: connection_builder.build).next_data["buildId"]
        end
        auth_cookies_fetcher = proc do
          ENV["BUCKLER_AUTH_COOKIES"] || Api::AuthApi.new(connection: connection_builder.build)
            .authenticate(email:, password:)
        end

        Client.new(connection_builder:, auth_cookies_fetcher:, build_id_fetcher:)
      end

      private

      def default_client
        @default_client ||= build_client
      end

      def respond_to_missing?(...)
        default_client.respond_to?(...) || super
      end

      def method_missing(method_name, ...)
        default_client.send(method_name, ...)
      end
    end
  end
end
