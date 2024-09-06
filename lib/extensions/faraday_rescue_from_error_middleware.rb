class FaradayRescueFromErrorMiddleware < Faraday::Middleware
  def call(request_env)
    @app.call(request_env)
  rescue Faraday::ClientError, Faraday::ServerError => e
    options[:handler].call(e)
  end
end

Faraday::Middleware.register_middleware(rescue_from_error: FaradayRescueFromErrorMiddleware)
