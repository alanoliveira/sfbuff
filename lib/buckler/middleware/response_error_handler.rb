module Buckler
  module Middleware
    class ResponseErrorHandler < Faraday::Middleware
      def on_complete(env)
        handler.call(env) unless env.success?
      end

      private

      def handler
        @options.fetch(:handler)
      end
    end
  end
end
