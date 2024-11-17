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
      attr_writer :default_client

      def default_client
        @default_client ||= begin
          Client.new(
            connection_builder: ConnectionBuilder,
            auth_cookies_fetcher: method(:auth_cookies_fetcher),
            build_id_fetcher: method(:build_id_fetcher)
          )
        end
      end

      private

      def auth_cookies_fetcher
        AuthCookiesFetcherAdapters::Http.new.call ||
          AuthCookiesFetcherAdapters::SeleniumDriver.new.call ||
          AuthCookiesFetcherAdapters::Env.call ||
          raise("failed to retrieve auth_cookies")
      end

      def build_id_fetcher
        BuildIdFetcherAdapters::Http.new.call ||
          BuildIdFetcherAdapters::Env.call ||
          raise("failed to retrieve build_id")
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
