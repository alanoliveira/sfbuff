module Buckler
  module Middleware
    class NextApiErrorHandler < Faraday::Middleware
      def on_complete(env)
        return if env.success?

        analyzer = ResponseAnalyzer.new(env)

        if analyzer.not_found? && !analyzer.json?
          client.logger.info("resetting build_id due to a 404 and not json response")
          client.reset_build_id!
        end

        if analyzer.forbidden?
          client.logger.info("resetting authentication due to a 403 response")
          client.reset_authentication!
        end

        raise UnderMaintenance, env if analyzer.under_maintenance?
        raise RateLimitExceeded, env if analyzer.rate_limit_exceeded?

        raise HttpError, env
      end

      private

      def client
        @options.fetch(:client)
      end

      class ResponseAnalyzer
        def initialize(env)
          @env = env
        end

        def status = @env.status

        def not_found?
          status == 404
        end

        def forbidden?
          status == 403
        end

        def under_maintenance?
          status == 503
        end

        def rate_limit_exceeded?
          status == 405 && response_headers["x-amzn-waf-action"]
        end

        def json?
          content_type == "application/json"
        end

        def content_type
          response_headers["content-type"]
        end

        def response_headers
          @env.response_headers
        end
      end
    end
  end
end
