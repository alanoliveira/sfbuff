module Buckler
  module Api
    class ResponseErrorAnalyzer
      def initialize(response_env)
        @response_env = response_env
      end

      def status = @response_env.status

      def path_not_found?
        not_found? && !json?
      end

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
        @response_env.response_headers
      end
    end
  end
end
