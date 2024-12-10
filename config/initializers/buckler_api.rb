Rails.application.config.to_prepare do
  BucklerApi.email = ENV["BUCKLER_EMAIL"]
  BucklerApi.password = ENV["BUCKLER_PASSWORD"]
  BucklerApi.logger = Rails.logger.tagged("BucklerApi")
end
