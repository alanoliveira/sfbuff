Sentry.init do |config|
  config.dsn = ENV["SENTRY_DSN"]
  config.background_worker_threads = 1
  config.breadcrumbs_logger = [ :active_support_logger, :http_logger ]
  config.enable_tracing = false
  config.enabled_environments = [ "production" ]
  config.excluded_exceptions += [
    "BucklerApi::UnderMaintenance"
  ]
end
