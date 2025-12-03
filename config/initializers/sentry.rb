Sentry.init do |config|
  config.dsn = ENV["SFBUFF_SENTRY_DSN"]
  config.breadcrumbs_logger = [ :active_support_logger, :http_logger ]
  config.enabled_environments = [ "production" ]
  config.excluded_exceptions += [
    "BucklerApiClient::UnderMaintenance",
    "BucklerApiClient::Unauthorized"
  ]
end
