module Buckler
  module Api
    class Client
      attr_reader :connection_builder, :build_id_fetcher, :auth_cookies_fetcher

      def initialize(connection_builder:, build_id_fetcher:, auth_cookies_fetcher:)
        @connection_builder = connection_builder
        @build_id_fetcher = build_id_fetcher
        @auth_cookies_fetcher = auth_cookies_fetcher
        @error_handler_semaphore = Mutex.new

        update_build_id; update_auth_cookies
      end

      def next_client(locale: "en")
        NextApi.new(connection: build_connection(locale)).then { NextClient.new _1 }
      end

      private

      def update_build_id
        @build_id = @build_id_fetcher.call
      end

      def update_auth_cookies
        @auth_cookies = @auth_cookies_fetcher.call
      end

      def build_connection(locale)
        @connection_builder.build do |conf|
          conf.path_prefix = "/6/buckler/_next/data/#{@build_id}/#{locale}/"
          conf.headers["cookie"] = @auth_cookies
          conf.use Middleware::ResponseErrorHandler, handler: method(:handle_response_error)
        end
      end

      def handle_response_error(response_env)
        analyzer = ResponseErrorAnalyzer.new(response_env)

        @error_handler_semaphore.try_lock && begin
          update_build_id if analyzer.path_not_found?
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
end
