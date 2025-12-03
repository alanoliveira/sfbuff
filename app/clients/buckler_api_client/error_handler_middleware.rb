class BucklerApiClient::ErrorHandlerMiddleware < Faraday::Middleware
  def on_complete(env)
    return if env.success?

    case
    when env.status == 404 && env.response_headers["Content-Type"] == "text/html"
      BucklerApiClient::PageNotFound
    when env.status == 403
      BucklerApiClient::Unauthorized
    when env.status == 405 && env.response_headers["x-amzn-waf-action"]
      BucklerApiClient::RateLimitExceeded
    when env.status == 503
      BucklerApiClient::UnderMaintenance
    when (400..499).cover?(env.status)
      BucklerApiClient::RequestError
    when (500..599).cover?(env.status)
      BucklerApiClient::ServerError
    else
      BucklerApiClient::HttpError
    end.then { raise it, env.response }
  end
end
